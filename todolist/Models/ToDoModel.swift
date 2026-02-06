import Foundation

struct Todo: Identifiable{
    let id: UUID
    let title: String
    var isCompleted: Bool
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
    }
}
