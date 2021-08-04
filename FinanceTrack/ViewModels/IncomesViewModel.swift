import Foundation

class IncomesViewModel {
    private var incomesRepository: IncomesRepository
    private var balanceRepository: BalanceRepository
    
    init() {
        incomesRepository = DIContainer.incomesRepository
        balanceRepository = DIContainer.balanceRepository
    }
    
    func addNewIncome(amount: Double, date: Date) {
        incomesRepository.add(amount: amount, date: date)
        balanceRepository.add(amount: amount)
    }
    
    func getTotal(for period: Period) -> Double {
        return incomesRepository.getTotal(for: period)
    }
}
