import Foundation

protocol Expense {
    var amount: Int { get }
    var category: Category { get }
    var date: Date { get }
    var info: String { get }
}

typealias GroupedExpenses = [Date: [Expense]]
typealias GroupedExpensesByPeriod = [String: [String: Int]]

struct TotalExpenseForDate {
    var amount: Double
    var date: Date
}

