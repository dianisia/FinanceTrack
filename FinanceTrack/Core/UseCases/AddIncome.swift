import Foundation

protocol AddIncome {
    func callAsFunction(amount: Int, date: Date)
}

class AddIncomeImpl: AddIncome {
    private let repository: IncomesRepository
    
    init(repository: IncomesRepository) {
        self.repository = repository
    }
    
    func callAsFunction(amount: Int, date: Date) {
        repository.add(amount: amount, date: date)
    }
}
