import Foundation

class ExpensesViewModel {
    private var repository: ExpensesRepository
    
    init() {
        repository = RealmExpensesRepository()
    }
    
    var expenses: GroupedExpenses {
        get {
            repository.listGroupedByDate(period: .allTime)
        }
    }
    
    func addNewExpense(amount: Int, categoryId: String, date: Date, info: String) {
        repository.add(amount: amount, categoryId: categoryId, date: date, info: info)
    }
    
    func getTotal(period: Period) -> [TotalExpenseForDate]  {
        return repository.getTotal(period: period)
    }
}
