import Foundation

struct Post {
    let id: String
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
    
    init(author: String, description: String, image: String, likes: Int, views: Int) {
        self.id = UUID().uuidString   // стабильный уникальный идентификатор
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}
