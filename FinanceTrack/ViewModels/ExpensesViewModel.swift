import Foundation

class ExpensesViewModel: ExpensesViewModelProtocol {
    var expensesRepository: ExpensesRepository
    var balanceRepository: BalanceRepository
    
    init() {
        expensesRepository = RealmExpensesRepository()
        balanceRepository = RealmBalanceRepository()
    }
    
    var expenses: ExpensesForDate {
        get {
            listGroupedByDate(period: .allTime)
        }
    }
    
    func addNewExpense(amount: Double, categoryId: String, date: Date, info: String) {
        expensesRepository.add(amount: amount, categoryId: categoryId, date: date, info: info)
        balanceRepository.substract(amount: amount)
    }
        
    func getTotalForCategory(period: Period, completion: @escaping ([TotalExpenseForCategory]) -> ()) {
        let expenses = expensesRepository.listAll(period: period)
        DispatchQueue.global().async { [unowned self] in
            let groupedExpenses = self.groupByCategory(expenses: expenses)
            let total = self.countTotalForCategories(expenses: groupedExpenses)
            DispatchQueue.main.async {
                completion(total)
            }
        }
        
    }
}
