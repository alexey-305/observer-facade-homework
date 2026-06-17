import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func savePost(id: String, title: String, text: String, author: String, likes: Int, imageName: String?) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let existing = try context.fetch(fetchRequest)
            if !existing.isEmpty {
                print("⏳ Пост уже сохранён")
                return
            }
        } catch {
            print("❌ Ошибка проверки: \(error)")
        }
        
        let post = FavoritePost(context: context)
        post.id = id
        post.titleText = title
        post.postText = text
        post.authorName = author
        post.likesCount = Int64(likes)
        post.createdAt = Date()
        post.imageName = imageName
        
        do {
            try context.save()
            print("✅ Пост сохранён в CoreData")
        } catch {
            print("❌ Ошибка сохранения: \(error)")
        }
    }
    
    func fetchAllPosts() -> [FavoritePost] {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ Ошибка загрузки: \(error)")
            return []
        }
    }
    
    func deletePost(_ post: FavoritePost) {
        context.delete(post)
        do {
            try context.save()
            print("✅ Пост удалён")
        } catch {
            print("❌ Ошибка удаления: \(error)")
        }
    }
}
