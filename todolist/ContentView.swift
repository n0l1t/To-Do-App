import SwiftUI

struct ContentView: View {
    private let todosKey = "todos_key"
    @State var newTitle: String = ""
    @State var showAddModalWindow: Bool = false
    @State private var isComplitetsCollapsed: Bool = false
    @State var todos:[Todo] = []
    var complitedTodos: [Todo] { todos.filter{$0.isCompleted} }
    var activeTodos: [Todo]{ todos.filter{!$0.isCompleted} }
    
    func saveTodos(){
        if let data = try? JSONEncoder().encode(todos){
            UserDefaults.standard.set(data, forKey: todosKey)
        }
    }
    
    func loadTodos(){
        guard let data = UserDefaults.standard.data(forKey: todosKey),
              let savedTodos = try? JSONDecoder().decode([Todo].self, from: data)
        else { return }
        
        todos = savedTodos
    }
    
    func toggle(_ todo:Todo){
        if let index = todos.firstIndex(where: {$0.id == todo.id}){
            withAnimation{
                todos[index].isCompleted.toggle()
            }
        }
    }
    
    func delete(_ todo:Todo){
        withAnimation{
            todos.removeAll{$0.id == todo.id}
        }
    }
    
    func clearAll(_ todos: [Todo]){
        for todo in todos{
            delete(todo)
        }
    }
    
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
                            Text("Пока нет активных задач")
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
                                toggle(todo)
                            }
                            .swipeActions{
                                Button(role: .destructive){
                                    delete(todo)
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
                                toggle(todo)
                            }
                            .swipeActions{
                                Button(role: .destructive){
                                    delete(todo)
                                }label:{
                                    Label("Удалить",systemImage:"trash")
                                }
                            }
                        }
                        Section{
                            if !complitedTodos.isEmpty{
                                Button(){
                                    clearAll(complitedTodos)
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
            }
            
            .sheet(isPresented: $showAddModalWindow){
                VStack(spacing: 15){
                    Text("New Task")
                        .font(.headline)
                    TextField("Entry task title", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    Button("Add"){
                        guard !newTitle.isEmpty else { return }
                        
                        let newTodo = Todo(title: newTitle)
                        todos.append(newTodo)
                        
                        newTitle = ""
                        showAddModalWindow = false
                    }
                    Button("Cancel"){
                        showAddModalWindow = false
                    }
                }
                .padding()
            }
        }
        .onAppear{
            loadTodos()
        }
        .onChange(of: todos){
            saveTodos()
        }
    }
}

#Preview {
    ContentView()
}
