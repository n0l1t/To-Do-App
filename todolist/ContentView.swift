import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewmodel = ToDoViewModel()
    
    @State private var selectedDate = Date()
    @State private var newType: TodoType = .empty
    @State private var newTitle: String = ""
    @State private var newDescription: String = ""
    @State var showAddModalWindow: Bool = false
    @State var showDescriptionWindow: Bool = false
    @State private var isComplitetsCollapsed: Bool = false
    
    var complitedTodos: [Todo] { viewmodel.todos.filter{$0.isCompleted} }
    var activeTodos: [Todo]{ viewmodel.todos.filter{!$0.isCompleted} }
    
    var completedHeader: some View{
        HStack{
            Text("Завершенные")
                .font(.headline)
            Spacer()
            Image(systemName: isComplitetsCollapsed ? "chevron.up" : "chevron.down")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation{
                isComplitetsCollapsed.toggle()
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section(){
                    if activeTodos.isEmpty{
                        VStack{
                            Text("Пока активных задач нет")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.secondary)
                        }
                    }else{
                        ForEach(activeTodos){ todo in
                            HStack{
                                Image(systemName: "circle")
                                Text(todo.title)
                                Spacer()
                            }
                            .onTapGesture {
                                viewmodel.toggle(todo)
                            }
                            .swipeActions{
                                Button(role: .destructive){
                                    viewmodel.delete(todo)
                                }label:{
                                    Label("Delete",systemImage:"trash")
                                }
                            }
                        }
                    }
                }
                Section(header: completedHeader){
                    if !isComplitetsCollapsed{
                        if complitedTodos.isEmpty{
                            VStack{
                                Text("Пока завершенных задач нет")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.secondary)
                            }
                        }
                        ForEach(complitedTodos) { todo in
                            HStack{
                                Image(systemName: "checkmark.circle.fill")
                                Text(todo.title)
                                    .foregroundStyle(.gray)
                                    .strikethrough()
                            }
                            .onTapGesture {
                                viewmodel.toggle(todo)
                            }
                            .swipeActions{
                                Button(role: .destructive){
                                    viewmodel.delete(todo)
                                }label:{
                                    Label("Удалить",systemImage:"trash")
                                }
                            }
                        }
                        Section{
                            if !complitedTodos.isEmpty{
                                Button(){
                                    viewmodel.clearAll(complitedTodos)
                                }label:{
                                    Label("Удалить все",systemImage:"trash")
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Мои задачи")
            .toolbar{
                Button{
                    showAddModalWindow = true
                } label:{
                    Image(systemName: "plus")
                }
                .glassEffect()
            }
            
            .sheet(isPresented: $showAddModalWindow){
                HStack(alignment: .center){
                    Text("Новая задача")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button{
                        showAddModalWindow = false
                    } label:{
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                            .padding(10)
                    }
                    .foregroundColor(.red)
                    .glassEffect()

                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10,trailing: 20))
                VStack{
                    List{
                        DatePicker(
                            "Выберете время и дату",
                            selection: $selectedDate,
                            displayedComponents: [.date,.hourAndMinute]
                        )
                        .datePickerStyle(.wheel)
                        Section{
                            TextField("Что нужно сдлеать?", text: $newTitle)
                            TextField("Описание", text: $newDescription)
                                .padding(EdgeInsets(top:0,leading:0,bottom:50,trailing:0))
                        }
                        Picker("Выберете тег", selection: $newType){
                            Text("Жизнь").tag(TodoType.life)
                            Text("Работа").tag(TodoType.work)
                            Text("Саморазвите").tag(TodoType.personal)
                        }
                    }
                    HStack(alignment: .bottom){
                        Button("Создать"){
                            guard !newTitle.isEmpty else {return}
                            
                            let newTodo = Todo(title: newTitle)
                            //let newTodo = Todo(title: newTitle, date: selectedDate, type: newType)
                            viewmodel.todos.append(newTodo)
                            newTitle = ""
                            newType = .empty
                            
                            showAddModalWindow = false
                        }
                        .padding(12)
                    }
                }
            }
        }
        .onAppear{
            viewmodel.loadTodos()
        }
        .onChange(of: viewmodel.todos){
            viewmodel.saveTodos()
        }
    }
}

#Preview {
    ContentView()
}
