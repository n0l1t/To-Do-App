import Foundation
import Combine

final class ToDoViewModel: ObservableObject{
    
    @Published var selectedDate: Date = Date()
    @Published var todos: [Todo] = []
    
    private let todosKey = "todos_key"
    private let calendar = Calendar.current
    
    init() {
        loadTodos()
        setupAutosave()
    }
    
    var complitedTodos: [Todo] { todos.filter{$0.isCompleted} }
    var activeTodos: [Todo]{ todos.filter{!$0.isCompleted} }
    
    private var selectedDay: Date {
        calendar.startOfDay(for: selectedDate)
    }
    
    var todosForSelectedDay: [Todo] {
        todos.filter {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    var todosByDay: [Date: [Todo]] {
        Dictionary(
            grouping: todos,
            by: { calendar.startOfDay(for: $0.date) }
        )
    }
    
    var sortedDays: [Date] {
        todosByDay.keys.sorted()
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
