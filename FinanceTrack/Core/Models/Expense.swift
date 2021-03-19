import Foundation

protocol Expense {
    var amount: Int { get }
    var category: Category { get }
    var date: Date { get }
    var info: String { get }
}

typealias GroupedExpenses = [String: [Expense]]

