import Foundation

class ExpensesViewModel {
    private var expensesRepository: ExpensesRepository
    private var balanceRepository: BalanceRepository
    
    init() {
        expensesRepository = RealmExpensesRepository()
        balanceRepository = RealmBalanceRepository()
    }
    
    var expenses: ExpensesForDate {
        get {
            expensesRepository.listGroupedByDate(period: .allTime)
        }
    }
    
    func addNewExpense(amount: Double, categoryId: String, date: Date, info: String) {
        expensesRepository.add(amount: amount, categoryId: categoryId, date: date, info: info)
        balanceRepository.substract(amount: amount)
    }
    
    func getTotalForDate(period: Period) -> [TotalExpenseForDate]  {
        return expensesRepository.getTotalForDate(period: period)
    }
    
    func getTotalForCategory(period: Period) -> [TotalExpenseForCategory] {
        return expensesRepository.getTotalForCategory(period: period)
    }
    
}
