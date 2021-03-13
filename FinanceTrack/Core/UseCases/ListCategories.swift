import Foundation

protocol ListCategories {
    func callAsFunction() -> [Category]
}

class ListCategoriesImpl: ListCategories {
    private let repository: CategoriesRepository
    
    init(repository: CategoriesRepository) {
        self.repository = repository
    }
    
    func callAsFunction() -> [Category] {
        return repository.listAll()
    }
}
