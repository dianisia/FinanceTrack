import Foundation

protocol CategoriesRepository {
    func listAll() -> [Category]
    func add(name: String, colorIndex: Int)
}
