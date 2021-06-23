import Foundation

protocol ExpensesViewModelProtocol: AnyObject {
    var expensesRepository: ExpensesRepository { set get }
    
    func listGroupedByDate(period: Period) -> ExpensesForDate
    func listGroupedByDate(for categoryId: String, period: Period) -> ExpensesForDate
    func getTotalForDate(period: Period, completion: @escaping ([TotalExpenseForDate]) -> Void)
    func getTotalForDate(period: Period, categoryId: String) -> [TotalExpenseForDate]
    func groupByDate(expenses: [Expense]) -> ExpensesForDate
    func groupByCategory(expenses: [Expense]) -> ExpensesForCategory
    func countTotalForDays(period: Period, expenses: ExpensesForDate) -> [TotalExpenseForDate]
    func countTotalForCategories(expenses: ExpensesForCategory) -> [TotalExpenseForCategory]
}

extension ExpensesViewModelProtocol {
    func listGroupedByDate(period: Period = .allTime) -> ExpensesForDate {
        return groupByDate(expenses: expensesRepository.listAll(period: period))
    }
    
    func listGroupedByDate(for categoryId: String, period: Period = .allTime) -> ExpensesForDate {
        let expenses = expensesRepository.listAll(period: period).filter { $0.category.categoryId == categoryId }
        return groupByDate(expenses: expenses)
    }
    
    func getTotalForDate(period: Period, completion: @escaping ([TotalExpenseForDate]) -> Void) {
        let expenses = listGroupedByDate(period: period)
        DispatchQueue.global().async { [unowned self] in
            let total = self.countTotalForDays(period: period, expenses: expenses)
            DispatchQueue.main.async {
                completion(total)
            }
        }
    }
    
    func getTotalForDate(period: Period, categoryId: String) -> [TotalExpenseForDate] {
        countTotalForDays(period: period, expenses: listGroupedByDate(for: categoryId, period: period))
    }
    
    func groupByDate(expenses: [Expense]) -> ExpensesForDate {
        Dictionary(grouping: expenses, by: { $0.date })
    }
    
    func groupByCategory(expenses: [Expense]) -> ExpensesForCategory {
        Dictionary(grouping: expenses, by: { $0.category.categoryId
        })
    }
    
    func countTotalForDays(period: Period, expenses: ExpensesForDate) -> [TotalExpenseForDate] {
        let periodItems: [Date] = Helper.getLastDays(for: period)
        var result: [TotalExpenseForDate] = []
        
        for periodItem in periodItems {
            result.append(TotalExpenseForDate(
                            amount: expenses.keys.contains(periodItem) ? expenses[periodItem]!.reduce(0) { $0 + Double($1.amount) } : 0.0,
                            date: periodItem)
            )
        }
        return result.sorted(by: { $0.date < $1.date })
    }
    
    func countTotalForCategories(expenses: ExpensesForCategory) -> [TotalExpenseForCategory] {
        var result: [TotalExpenseForCategory] = []
        for category in expenses.keys {
            result.append(TotalExpenseForCategory(
                            amount: expenses.keys.contains(category) ? expenses[category]!.reduce(0) { $0 + Double($1.amount) } : 0.0,
                            category: expenses[category]![0].category)
            )
        }
        return result.sorted(by: { $0.amount > $1.amount })
    }
}
