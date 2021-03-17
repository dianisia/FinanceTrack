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
}
