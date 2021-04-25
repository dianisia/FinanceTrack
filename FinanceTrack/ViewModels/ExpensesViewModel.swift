import Foundation

class ExpensesViewModel {
    private var repository: ExpensesRepository
    
    init() {
        repository = RealmExpensesRepository()
    }
    
    var expenses: GroupedExpenses {
        get {
            repository.listGroupedByDate()
        }
    }
    
    func addNewExpense(amount: Int, categoryId: String, date: Date, info: String) {
        repository.add(amount: amount, categoryId: categoryId, date: date, info: info)
    }
    
    func getTotalPeriod(period: Period) -> GroupedExpensesByPeriod  {
        return repository.getTotalForPeriod(period: period)
    }
}
