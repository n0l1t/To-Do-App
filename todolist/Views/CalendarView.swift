import SwiftUI

struct CalendarView: View{
    @ObservedObject var viewmodel: ToDoViewModel

    var body: some View{
        Text("Календарь")
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
