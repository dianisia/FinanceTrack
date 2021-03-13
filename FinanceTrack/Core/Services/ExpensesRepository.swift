import Foundation

protocol ExpensesRepository {
    func listAll() -> [Expense]
}
