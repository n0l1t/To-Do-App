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
    
    init(title: String, detail: String, type: TodoType, date: Date) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.type = type
        self.date = date
        self.detail = detail
    }
}
