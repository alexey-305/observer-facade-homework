import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    private let realm = try! Realm()
    
    // Сохранить цитату
    func saveQuote(text: String, category: String) {
        let quote = Quote(text: text, category: category)
        
        try! realm.write {
            realm.add(quote, update: .modified)
            
            // Обновляем или создаём категорию
            if let existingCategory = realm.object(ofType: Category.self, forPrimaryKey: category) {
                if !existingCategory.quotes.contains(where: { $0.text == text }) {
                    existingCategory.quotes.append(quote)
                }
            } else {
                let newCategory = Category(name: category)
                newCategory.quotes.append(quote)
                realm.add(newCategory, update: .modified)
            }
        }
    }
    
    // Получить все цитаты (сортировка по дате)
    func getAllQuotes() -> Results<Quote> {
        return realm.objects(Quote.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    // Получить все категории
    func getAllCategories() -> Results<Category> {
        return realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    // Получить цитаты по категории
    func getQuotes(for category: String) -> Results<Quote> {
        return realm.objects(Quote.self).filter("category == %@", category).sorted(byKeyPath: "createdAt", ascending: false)
    }
}
