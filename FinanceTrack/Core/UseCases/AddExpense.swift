import Foundation

protocol AddExpense {
    func callAsFunction(amount: Int, categoryId: String, date: Date, info: String)
}

class AddExpenseImpl: AddExpense {
    private let repository: ExpensesRepository
    
    init(repository: ExpensesRepository) {
        self.repository = repository
    }
    
    func callAsFunction(amount: Int, categoryId: String, date: Date, info: String) {
        repository.add(amount: amount, categoryId: categoryId, date: date, info: info)
    }
}
