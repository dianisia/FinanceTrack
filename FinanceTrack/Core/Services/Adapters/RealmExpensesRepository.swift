import Foundation
import RealmSwift

class RealmExpense: Object {
    @objc dynamic var _amount = 0
    @objc dynamic var _category: RealmCategory?
    @objc dynamic var _date = Date()
    @objc dynamic var _info = ""
}

extension RealmExpense: Expense {
    var amount: Int { return _amount }
    var category: Category { return _category ?? RealmCategory() } //TODO
    var date: Date { return _date }
    var info: String { return _info }
}

class RealmExpensesRepository: ExpensesRepository {
    func listAll() -> [Expense] {
        let realm = try! Realm()
        return Array(realm.objects(RealmExpense.self))
    }
    
    func add(amount: Int, categoryId: String, date: Date, info: String) {
        let realm = try! Realm()
        let expense = RealmExpense()
        expense._amount = amount
        expense._category = RealmCategoriesRepository().getForId(categoryId: categoryId)
        expense._date = date.trimTime()
        expense._info = info
        try! realm.write {
            realm.add(expense)
        }
    }
    
    func listGroupedByDate(period: Period = .allTime) -> ExpensesForDate {
        return groupByDate(
            expenses: period == .allTime ? listAll() :
                listAll().filter{ Helper.checkDateIsInPeriod(date: $0.date, period: period) }
        )
    }
    
    func listGroupedByDate(for categoryId: String, period: Period = .allTime) -> ExpensesForDate {
        var expenses = listAll()
            .filter { $0.category.categoryId == categoryId }
        if (period != .allTime) {
            expenses = expenses.filter{ Helper.checkDateIsInPeriod(date: $0.date, period: period) }
        }
        
        return groupByDate(expenses: expenses)
    }
    
    
    func getTotalForDate(period: Period) -> [TotalExpenseForDate] {
        return countTotalForDays(period: period, expenses: listGroupedByDate())
    }
    
    func getTotalForDate(period: Period, categoryId: String) -> [TotalExpenseForDate] {
        return countTotalForDays(period: period, expenses: listGroupedByDate(for: categoryId))
    }
    
    func getTotalForCategory(period: Period) -> [TotalExpenseForCategory] {
        let expenses = period == .allTime ? listAll() :
            listAll().filter{ Helper.checkDateIsInPeriod(date: $0.date, period: period) }
        return countTotalForCategories(expenses: groupByCategory(expenses: expenses))
    }
    
    private func groupByDate(expenses: [Expense]) -> ExpensesForDate {
        return Dictionary(grouping: expenses, by: { $0.date })
    }
    
    private func groupByCategory(expenses: [Expense]) -> ExpensesForCategory {
        return Dictionary(grouping: expenses, by: { $0.category.categoryId })
    }
    
    private func countTotalForDays(period: Period, expenses: ExpensesForDate) -> [TotalExpenseForDate] {
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
    
    private func countTotalForCategories(expenses: ExpensesForCategory) -> [TotalExpenseForCategory] {
        var result: [TotalExpenseForCategory] = []
        for category in expenses.keys {
            result.append(TotalExpenseForCategory(
                            amount: expenses.keys.contains(category) ? expenses[category]!.reduce(0) { $0 + Double($1.amount) } : 0.0,
                            category: expenses[category]![0].category)
            )
        }
        return result.sorted(by: { $0.amount < $1.amount })
    }
}
