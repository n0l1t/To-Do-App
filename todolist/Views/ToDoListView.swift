import SwiftUI

extension Date{
    var todoDisplay: String{
        formatted(
            .relative(presentation: .named)
                .locale(Locale(identifier: "ru_RU")))
    }
}

struct TagView: View {
    let todo: Todo
    
    var capsuleMain: some View{
        Text(todo.type.title)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
    }
    
    var body: some View {
        switch todo.type{
        case .life:
            capsuleMain
                .background(Capsule().fill(.teal).opacity(todo.isCompleted ? 0.2 : 0.8))
        case .work:
            capsuleMain
                .background(Capsule().fill(.indigo).opacity(todo.isCompleted ? 0.2 : 0.8))
        case .personal:
            capsuleMain
                .background(Capsule().fill(.orange).opacity(todo.isCompleted ? 0.2 : 0.8))
        case .empty:
            capsuleMain
                .background(Capsule().fill(.gray).opacity(todo.isCompleted ? 0.2 : 0.8))
        }
        
    }
}

struct TodoRowView: View{
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View{
        HStack{
            Image(systemName: "circle")
            VStack(alignment: .leading){
                if !todo.isCompleted{
                    Text(todo.title)
                        .font(.headline)
                }else{
                    Text(todo.title)
                        .foregroundStyle(.gray)
                        .strikethrough()
                }
                if !todo.detail.isEmpty && !todo.isCompleted{
                    Text(todo.detail)
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                    
                }
            }
            Spacer()
            VStack(alignment: .center){
                TagView(todo: todo)
                if !todo.isCompleted{
                    Text(todo.date.todoDisplay)
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                }
            }
            
        }
        .onTapGesture {
            withAnimation{
                onToggle()
            }
        }
        .swipeActions{
            Button(role: .destructive){
                onDelete()
            }label:{
                Label("Delete",systemImage:"trash")
            }
        }
    }
}

struct ToDoListView: View {
    
    @ObservedObject var viewmodel: ToDoViewModel
    
    @State private var selectedDate = Date()
    @State private var newType: TodoType = .empty
    @State private var newTitle: String = ""
    @State private var newDescription: String = ""
    
    @State var showAddModalWindow: Bool = false
    @State var showDescriptionWindow: Bool = false
    @State private var isComplitetsCollapsed: Bool = false
    @State private var titleInputError: Bool = false
    
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
        List{
            Section(){
                if viewmodel.activeTodos.isEmpty{
                    VStack{
                        Text("Пока активных задач нет")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                }else{
                    ForEach(viewmodel.activeTodos){ todo in
                        TodoRowView(todo: todo,onToggle: {viewmodel.toggle(todo)}, onDelete: {viewmodel.delete(todo)})
                    }
                }
            }
            Section(header: completedHeader){
                if !isComplitetsCollapsed{
                    if viewmodel.complitedTodos.isEmpty{
                        VStack{
                            Text("Пока завершенных задач нет")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.secondary)
                        }
                    }
                    ForEach(viewmodel.complitedTodos) { todo in
                        TodoRowView(todo: todo,onToggle: {viewmodel.toggle(todo)}, onDelete: {viewmodel.delete(todo)})
                    }
                    Section{
                        if !viewmodel.complitedTodos.isEmpty{
                            Button(){
                                viewmodel.clearAll(viewmodel.complitedTodos)
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showAddModalWindow = true
                } label: {
                    Image(systemName: "plus")
                }
            }
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
                        Text("Без тега").tag(TodoType.empty)
                    }
                }
                HStack(alignment: .bottom){
                    Button("Создать"){
                        guard !newTitle.isEmpty else {
                            titleInputError = true
                            return
                        }
                        let newTodo = Todo(title: newTitle, detail: newDescription, type: newType, date:selectedDate)
                        viewmodel.todos.append(newTodo)
                        newTitle = ""
                        newType = .empty
                        
                        showAddModalWindow = false
                    }
                    .alert("Ошибка", isPresented: $titleInputError){
                        Button("OK", role: .cancel){}
                    } message: {
                        Text("Задача не может быть пустой")
                    }
                    .padding(12)
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
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        ToDoListView(
            viewmodel: ToDoViewModel()
        )
    }
}
