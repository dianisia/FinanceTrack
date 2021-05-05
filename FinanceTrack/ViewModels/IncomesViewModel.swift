import Foundation

class IncomesViewModel {
    private var repository: IncomesRepository
    
    init() {
        repository = RealmIncomesRepository()
    }
    
    func addNewIncome(amount: Int, date: Date) {
        repository.add(amount: amount, date: date)
    }
    
    func getTotal(for period: Period) -> Double {
        return repository.getTotal(for: period)
    }
}
