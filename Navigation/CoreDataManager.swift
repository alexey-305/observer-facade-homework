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
    
    // Основной контекст для чтения (главный поток)
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Фоновый контекст для записи (background поток)
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - CRUD Operations (на backgroundContext)
    
    func savePost(id: String, title: String, text: String, author: String, likes: Int, imageName: String?) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let existing = try self.backgroundContext.fetch(fetchRequest)
                if !existing.isEmpty {
                    print("⏳ Пост уже сохранён")
                    return
                }
            } catch {
                print("❌ Ошибка проверки: \(error)")
            }
            
            let post = FavoritePost(context: self.backgroundContext)
            post.id = id
            post.titleText = title
            post.postText = text
            post.authorName = author
            post.likesCount = Int64(likes)
            post.createdAt = Date()
            post.imageName = imageName
            
            do {
                try self.backgroundContext.save()
                print("✅ Пост сохранён в CoreData (background)")
            } catch {
                print("❌ Ошибка сохранения: \(error)")
            }
        }
    }
    
    func fetchAllPosts() -> [FavoritePost] {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20  // ← ОПТИМИЗАЦИЯ
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Ошибка загрузки: \(error)")
            return []
        }
    }
    
    // MARK: - DELETE
    
    func deletePost(_ post: FavoritePost) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            // Получаем объект в контексте background
            let objectID = post.objectID
            let object = self.backgroundContext.object(with: objectID)
            
            self.backgroundContext.delete(object)
            
            do {
                try self.backgroundContext.save()
                print("✅ Пост удалён (background)")
            } catch {
                print("❌ Ошибка удаления: \(error)")
            }
        }
    }
    
    // MARK: - FILTER
    
    func fetchPosts(byAuthor author: String) -> [FavoritePost] {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "authorName CONTAINS[cd] %@", author)
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20  // ← ОПТИМИЗАЦИЯ
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Ошибка фильтрации: \(error)")
            return []
        }
    }
}
