import SwiftUI

struct SettingsView: View{
    @ObservedObject var viewmodel: ToDoViewModel
    
    @AppStorage("isTagEnabled")
    private var isTagEnabled: Bool = true
    @AppStorage("isTimeEnabled")
    private var isTimeEnabled: Bool = true
    @AppStorage("notificationsEnabled")
    var notificationsEnabled: Bool = true
    
    var body: some View{
        List{
            Section{
                Toggle(isOn: $isTagEnabled){
                    Text("Отображать теги на главном экране")

                }
                Toggle(isOn: $isTimeEnabled){
                    Text("Отобразить время до дедлайна")

                }
            }
        }
            .navigationTitle("Настройки")
        
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
