import Foundation

enum TodoType: Hashable, Codable{
    case work, life, personal, empty
    
    var title: String{
        switch self{
        case .work:
            return "Работа"
        case .life:
            return "Жизнь"
        case .personal:
            return "Саморазвите"
        case .empty:
            return "Без тега"
        }
    }
}

struct Todo: Identifiable, Codable, Equatable{
    let id: UUID
    let title: String
    var isCompleted: Bool
    let type: TodoType
    let detail: String
    let date: Date
    
    init(title: String, detail: String, type: TodoType) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.type = type
        self.date = Date()
        self.detail = detail
    }
}
