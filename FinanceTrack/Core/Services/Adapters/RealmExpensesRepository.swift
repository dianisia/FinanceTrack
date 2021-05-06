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
    
    func listGroupedByDate() -> GroupedExpenses {
        let expenses = listAll()
        var result: GroupedExpenses = [:]
        for expense in expenses {
            let currDate = expense.date
            if result.keys.contains(currDate) {
                result[currDate]?.append(expense)
            } else {
                result[currDate] = [expense]
            }
        }
        return result
    }
    
    func getTotalForPeriod(period: Period) -> [TotalExpenseForDate] {
        let periodItems: [Date] = Helper.getLastDays(for: period)
        let allExpenses = listGroupedByDate()
        var result: [TotalExpenseForDate] = []
      
        for periodItem in periodItems {
            result.append(TotalExpenseForDate(
                            amount: allExpenses.keys.contains(periodItem) ? allExpenses[periodItem]!.reduce(0) { $0 + Double($1.amount) } : 0.0,
                            date: periodItem)
            )
        }
        result = result.sorted(by: { $0.date < $1.date })
        return result
    }
}
