import SwiftUI

struct SettingsView: View{
    @ObservedObject var viewmodel: ToDoViewModel
    var body: some View{
        Text("calendar")
            .navigationTitle("Settings")
        
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        SettingsView(
            viewmodel: ToDoViewModel()
        )
    }
}
