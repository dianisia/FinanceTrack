import Foundation

class CategoriesViewModel {
    private var repository: CategoriesRepository
        
    init() {
        repository = DIContainer.categoriesRepository
    }
    
    var categories: [Category] {
        get {
            repository.listAll()
        }
    }
    
    func addNewCategory(name: String, colorIndex: Int) {
        repository.add(name: name, colorIndex: colorIndex)
    }
    
    func getColorForCategory(id: String) -> Int {
        repository.getColor(id: id)
    }
}
