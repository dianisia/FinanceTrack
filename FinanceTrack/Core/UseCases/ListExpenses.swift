import Foundation

protocol ListExpenses {
    func callAsFunction() -> [Expense]
}

class ListExpensesImpl: ListExpenses {
    private let repository: ExpensesRepository
    
    init(repository: ExpensesRepository) {
        self.repository = repository
    }
    
    func callAsFunction() -> [Expense] {
        return repository.listAll()
    }
    
}
