import SwiftUI

struct ContentView: View {
    @State var newTitle: String = ""
    @State var showAddModalWindow: Bool = false
    @State var todos:[Todo] = [
        Todo(title: "test"),
        Todo(title: "test 2")
    ]
    var complitedTodos: [Todo] {
        todos.filter{$0.isCompleted}
    }
    var activeTodos: [Todo]{
        todos.filter{!$0.isCompleted}
    }
    
    func toggle(_ todo:Todo){
        if let index = todos.firstIndex(where: {$0.id == todo.id}){
            todos[index].isCompleted.toggle()
        }
    }
    
    func delete(_ todo:Todo){
        todos.removeAll{$0.id == todo.id}
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section(){
                    if activeTodos.count == 0{
                        VStack{
                            Text("Нет активных задач")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.secondary)
                            Button{
                                showAddModalWindow = true
                            } label:{
                                Label("Cоздать", systemImage: "plus")
                            }
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
                
                Section("Завершенные"){
                    if complitedTodos.count == 0{
                        Text("Пока нет выполненых задач")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                    }else{
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
                                    Label("Delete",systemImage:"trash")
                                }
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
    }
}

#Preview {
    ContentView()
}
