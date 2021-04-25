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
        expense._date = date
        expense._info = info
        try! realm.write {
            realm.add(expense)
        }
    }
    
    func listGroupedByDate() -> GroupedExpenses {
        let expenses = listAll()
        var result: GroupedExpenses = [:]
        for expense in expenses {
            let currDate = expense.date.monthDateFormate()
            if result.keys.contains(currDate) {
                result[currDate]?.append(expense)
            } else {
                result[currDate] = [expense]
            }
        }
        return result
    }
    
    func getTotalForPeriod(period: Period) -> GroupedExpensesByPeriod {
        var result: GroupedExpensesByPeriod = [:]
        var periodItems: [String] = []
        switch period {
        case .week:
            periodItems = Helper.getLastWeekDays().map{ $0.monthDateFormate() }
        default:
            periodItems = []
        }
        
        let currExpenses = listGroupedByDate()
        for item in periodItems {
            result[item] = [:]
            if let expensesForDate = currExpenses[item] {
                expensesForDate.forEach { expense in
                    let categoryId = expense.category.categoryId
                    result[item]![categoryId] = result[item]!.keys.contains(categoryId) ?
                        result[item]![categoryId]! + expense.amount :
                        expense.amount
                }
            }
        }
        print(result)
        return result
    }
}
