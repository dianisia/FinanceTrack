import Foundation

class ExpensesViewModel {
    private var repository: ExpensesRepository
    
    init() {
        repository = RealmExpensesRepository()
    }
    
    var expenses: ExpensesForDate {
        get {
            repository.listGroupedByDate(period: .allTime)
        }
    }
    
    func addNewExpense(amount: Int, categoryId: String, date: Date, info: String) {
        repository.add(amount: amount, categoryId: categoryId, date: date, info: info)
    }
    
    func getTotalForDate(period: Period) -> [TotalExpenseForDate]  {
        return repository.getTotalForDate(period: period)
    }
    
    func getTotalForCategory(period: Period) -> [TotalExpenseForCategory] {
        return repository.getTotalForCategory(period: period)
    }
    
}
