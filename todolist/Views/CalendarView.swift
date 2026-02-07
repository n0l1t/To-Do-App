import SwiftUI

extension Date{
    var headderDate: String{
        formatted(
            .dateTime
                .day()
                .month(.wide)
                .locale(Locale(identifier: "ru_RU")))
    }
}

struct CalendarView: View{
    @ObservedObject var viewmodel: ToDoViewModel
    @State private var selectedDate = Date()
    
    var body: some View{
        List{
            VStack{
                DatePicker(
                    "Выберите день",
                    selection: $viewmodel.selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
            }
            Section{
                if viewmodel.todosForSelectedDay.isEmpty {
                    Text("Нет задач")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    ForEach(viewmodel.todosForSelectedDay) { todo in
                        TodoRowView(todo: todo,onToggle: {viewmodel.toggle(todo)}, onDelete: {viewmodel.delete(todo)})
                    }
                }
            }
        }
        .navigationTitle("Календарь")
        
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        CalendarView(
            viewmodel: ToDoViewModel()
        )
    }
}
