import Foundation

protocol ExpensesRepository {
    func listAll() -> [Expense]
    func listAll(period: Period) -> [Expense]
    func add(amount: Double, categoryId: String, date: Date, info: String)
}
