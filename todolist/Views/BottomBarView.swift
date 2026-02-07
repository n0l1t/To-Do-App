import SwiftUI

struct BottomBarView: View {

    @StateObject private var viewModel = ToDoViewModel()

    var body: some View {
        TabView {

            NavigationStack {
                ToDoListView(viewmodel: viewModel)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Задачи")
            }

            NavigationStack {
                CalendarView(viewmodel: viewModel)
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Календарь")
            }

            NavigationStack {
                SettingsView(viewmodel: viewModel)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Настройки")
            }
        }
    }
}
