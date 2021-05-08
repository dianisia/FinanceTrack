import Foundation

protocol CategoriesRepository {
    func listAll() -> [Category]
    func add(name: String, colorIndex: Int)
    func getForId(categoryId: String) -> RealmCategory
    func getColor(id: String) -> Int
}
