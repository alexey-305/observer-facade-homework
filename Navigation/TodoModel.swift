import Foundation

// MARK: - Модель для задания 1
struct TodoModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
