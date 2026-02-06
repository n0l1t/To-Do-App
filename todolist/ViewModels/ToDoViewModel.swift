import Foundation
import Combine

final class ToDoViewModel: ObservableObject{
    
    @Published var todos: [Todo] = []
    private let todosKey = "todos_key"
    
    init() {
        loadTodos()
        setupAutosave()
    }
    
    func toggle(_ todo:Todo){
        if let index = todos.firstIndex(where: {$0.id == todo.id}){
                todos[index].isCompleted.toggle()
        }
    }
    
    func delete(_ todo:Todo){
            todos.removeAll{$0.id == todo.id}
    }
    
    func clearAll(_ todos: [Todo]){
        for todo in todos{
            delete(todo)
        }
    }
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
    
    private func setupAutosave(){
        $todos
            .sink {[weak self] _ in
                self?.saveTodos()
            }
    }
    
}
