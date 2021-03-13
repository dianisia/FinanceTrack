import Foundation

protocol AddCategory {
    func callAsFunction(name: String, colorIndex: Int)
}

class AddCategoryImpl: AddCategory {
    private let repository: CategoriesRepository
    
    init(repository: CategoriesRepository) {
        self.repository = repository
    }
    
    func callAsFunction(name: String, colorIndex: Int) {
        return repository.add(name: name, colorIndex: colorIndex)
    }
}
