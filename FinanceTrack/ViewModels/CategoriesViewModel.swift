import Foundation

class CategoriesViewModel {
    private var repository: CategoriesRepository
    private var listCategories: ListCategories
    private var addCategory: AddCategory
    
    init() {
        repository = RealmCategoriesRepository()
        listCategories = ListCategoriesImpl(repository: repository)
        addCategory = AddCategoryImpl(repository: repository)
    }
    
    var categories: [Category] {
        get {
            return self.listCategories()
        }
    }
    
    func addCategory(name: String, colorIndex: Int) {
        repository.add(name: name, colorIndex: colorIndex)
    }
}
