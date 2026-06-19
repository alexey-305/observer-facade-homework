import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private var realm: Realm?
    
    private init() {
        do {
            realm = try Realm()
            print("✅ Realm инициализирован успешно")
        } catch {
            print("❌ Ошибка инициализации Realm: \(error)")
        }
    }
    
    func saveQuote(text: String, category: String) {
        guard let realm = realm else {
            print("❌ Realm не инициализирован")
            return
        }
        
        let quote = Quote(text: text, category: category)
        
        do {
            try realm.write {
                realm.add(quote, update: .modified)
                
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
            print("✅ Цитата сохранена")
        } catch {
            print("❌ Ошибка сохранения цитаты: \(error)")
        }
    }
    
    func getAllQuotes() -> Results<Quote>? {
        guard let realm = realm else { return nil }
        return realm.objects(Quote.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func getAllCategories() -> Results<Category>? {
        guard let realm = realm else { return nil }
        return realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    func getQuotes(for category: String) -> Results<Quote>? {
        guard let realm = realm else { return nil }
        return realm.objects(Quote.self).filter("category == %@", category).sorted(byKeyPath: "createdAt", ascending: false)
    }
}
