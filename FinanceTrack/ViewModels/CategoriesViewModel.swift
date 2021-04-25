import Foundation

class CategoriesViewModel {
    private var repository: CategoriesRepository
    
//    var onCategoryAdd
    
    init() {
        repository = RealmCategoriesRepository()
    }
    
    var categories: [Category] {
        get {
            repository.listAll()
        }
    }
    
    func addNewCategory(name: String, colorIndex: Int) {
        repository.add(name: name, colorIndex: colorIndex)
    }
}
