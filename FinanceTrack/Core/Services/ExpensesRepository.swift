import Foundation

protocol ExpensesRepository {
    func listAll() -> [Expense]
    func add(amount: Int, categoryId: String, date: Date, info: String)
}
