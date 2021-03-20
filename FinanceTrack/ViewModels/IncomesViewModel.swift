import Foundation

class IncomesViewModel {
    private var repository: IncomesRepository
    private var addIncome: AddIncome
    
    init() {
        repository = RealmIncomesRepository()
        addIncome = AddIncomeImpl(repository: repository)
    }
    
    func addNewIncome(amount: Int, date: Date) {
        addIncome(amount: amount, date: date)
    }
}
