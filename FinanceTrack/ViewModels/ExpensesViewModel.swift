import Foundation

class ExpensesViewModel {
    private var repository: ExpensesRepository
    private var listExpenses: ListExpenses
    private var addExpense: AddExpense
    
    init() {
        repository = RealmExpensesRepository()
        listExpenses = ListExpensesImpl(repository: repository)
        addExpense = AddExpenseImpl(repository: repository)
    }
    
    var expenses: [Expense] {
        get {
            return listExpenses()
        }
    }
    
    func addNewExpense(amount: Int, categoryId: String, date: Date, info: String) {
        addExpense(amount: amount, categoryId: categoryId, date: date, info: info)
    }
}
