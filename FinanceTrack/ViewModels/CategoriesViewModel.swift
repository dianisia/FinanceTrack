import Foundation

class CategoriesViewModel {
    private var repository: CategoriesRepository
    private var listCategories: ListCategories
    private var addCategory: AddCategory
    
//    var onCategoryAdd
    
    init() {
        repository = RealmCategoriesRepository()
        listCategories = ListCategoriesImpl(repository: repository)
        addCategory = AddCategoryImpl(repository: repository)
    }
    
    var categories: [Category] {
        get {
            return listCategories()
        }
    }
    
    func addNewCategory(name: String, colorIndex: Int) {
        self.addCategory(name: name, colorIndex: colorIndex)
    }
}
