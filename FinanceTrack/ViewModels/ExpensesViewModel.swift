import Foundation

class ExpensesViewModel: ExpensesViewModelProtocol {
    var expensesRepository: ExpensesRepository
    var balanceRepository: BalanceRepository
    
    init() {
        expensesRepository = DIContainer.expensesRepository
        balanceRepository = DIContainer.balanceRepository
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
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let groupedExpenses = self.groupByCategory(expenses: expenses)
            let total = self.countTotalForCategories(expenses: groupedExpenses)
            DispatchQueue.main.async {
                completion(total)
            }
        }
        
    }
}
