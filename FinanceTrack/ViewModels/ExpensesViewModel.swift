import Foundation

class ExpensesViewModel {
    private var repository: ExpensesRepository
    private var listExpenses: ListExpenses
    private var listGroupedExpenses: ListGroupedExpenses
    private var addExpense: AddExpense
    
    init() {
        repository = RealmExpensesRepository()
        listExpenses = ListExpensesImpl(repository: repository)
        addExpense = AddExpenseImpl(repository: repository)
        listGroupedExpenses = ListGroupedExpensesImpl(repository: repository)
    }
    
    var expenses: GroupedExpenses {
        get {
            listGroupedExpenses()
        }
    }
    
    func addNewExpense(amount: Int, categoryId: String, date: Date, info: String) {
        addExpense(amount: amount, categoryId: categoryId, date: date, info: info)
    }
}
