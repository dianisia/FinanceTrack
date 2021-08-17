import Foundation
import RealmSwift

class RealmExpense: Object {
    @objc dynamic var _amount = 0.0
    @objc dynamic var _category: RealmCategory?
    @objc dynamic var _date = Date()
    @objc dynamic var _info = ""
}

extension RealmExpense: ExpenseProtocol {
    var amount: Double { return _amount }
    var category: Category { return Category(realmCategory: _category ?? RealmCategory())}
    var date: Date { return _date }
    var info: String { return _info }
}

class RealmExpensesRepository: ExpensesRepository {
    private let realm = try! Realm()
    
    func listAll() -> [Expense] {
        return Array(realm.objects(RealmExpense.self)).map{ Expense(realmExpense: $0) }
    }
    
    func listAll(period: Period) -> [Expense] {
        let interval = Helper.getDateInterval(period: period)
        return Array(realm.objects(RealmExpense.self).filter("_date BETWEEN %@", [interval.finish, interval.start]))
            .map{ Expense(realmExpense: $0) }
    }
    
    func add(amount: Double, categoryId: String, date: Date, info: String) {
        let expense = RealmExpense()
        expense._amount = amount
        expense._category = RealmCategoriesRepository().getForId(categoryId: categoryId)
        expense._date = date.trimTime()
        expense._info = info
        try? realm.write {
            realm.add(expense)
        }
    }
}
