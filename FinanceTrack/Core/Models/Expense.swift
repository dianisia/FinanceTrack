import Foundation

protocol ExpenseProtocol {
    var amount: Double { get }
    var category: Category { get }
    var date: Date { get }
    var info: String { get }
}

struct Expense: ExpenseProtocol {
    var amount: Double = 0.0
    var category: Category = Category()
    var date: Date = Date()
    var info: String = ""
    
    init(realmExpense: RealmExpense) {
        self.amount = realmExpense.amount
        self.category = realmExpense.category
        self.date = realmExpense.date
        self.info = realmExpense.info
    }
}

typealias ExpensesForDate = [Date: [Expense]]
typealias ExpensesForCategory = [String: [Expense]]

struct TotalExpenseForDate {
    var amount: Double
    var date: Date
}

struct TotalExpenseForCategory {
    var amount: Double
    var category: Category
}

