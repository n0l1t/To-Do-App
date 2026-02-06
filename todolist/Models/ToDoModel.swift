import Foundation

enum TodoType: Hashable, Codable{
    case work, life, personal, empty
}

struct Todo: Identifiable, Codable, Equatable{
    let id: UUID
    let title: String
    var isCompleted: Bool
    let type: TodoType
    //let descrtiption: String
    let date: Date
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.type = .life
        self.date = Date()
        //self.descrtiption = "test descrtiopton"
    }
}
