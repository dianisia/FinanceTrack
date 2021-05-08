import Foundation

protocol Expense {
    var amount: Int { get }
    var category: Category { get }
    var date: Date { get }
    var info: String { get }
}

typealias ExpensesForDate = [Date: [Expense]]
typealias ExpensesForCategory = [String: [Expense]]

struct TotalExpenseForDate {
    var amount: Double
    var date: Date
}

struct TotalExpenseForCategoryAndPeriod {
    var amount: Double
    var category: Category
}

