import Foundation

protocol ExpensesRepository {
    func listAll() -> [Expense]
    func listAll(period: Period) -> [Expense]
    
    func add(amount: Double, categoryId: String, date: Date, info: String)
    
    func listGroupedByDate(period: Period) -> ExpensesForDate
    func listGroupedByDate(for categoryId: String, period: Period) -> ExpensesForDate
    
    func getTotalForDate(period: Period) -> [TotalExpenseForDate]
    func getTotalForDate(period: Period, categoryId: String) -> [TotalExpenseForDate]
    
    func getTotalForCategory(period: Period) -> [TotalExpenseForCategory]
}
