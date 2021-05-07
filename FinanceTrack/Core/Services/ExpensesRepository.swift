import Foundation

protocol ExpensesRepository {
    func listAll() -> [Expense]
    func add(amount: Int, categoryId: String, date: Date, info: String)
    func listGroupedByDate(period: Period) -> GroupedExpenses
    func listGroupedByDate(for categoryId: String, period: Period) -> GroupedExpenses
    func getTotal(period: Period) -> [TotalExpenseForDate]
    func getTotal(period: Period, categoryId: String) -> [TotalExpenseForDate]
}
