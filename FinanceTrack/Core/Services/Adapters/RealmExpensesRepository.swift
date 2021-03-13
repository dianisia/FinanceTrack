import Foundation
import RealmSwift

class RealmExpense: Object {
    @objc dynamic var _amount = 0
    @objc dynamic var _category: RealmCategory?
    @objc dynamic var _date = Date()
}

extension RealmExpense: Expense {
    var amount: Int { return _amount }
    var category: Category { return _category ?? RealmCategory() } //TODO
    var date: Date { return _date }
}

class RealmExpensesRepository: ExpensesRepository {
    func listAll() -> [Expense] {
        let realm = try! Realm()
        return Array(realm.objects(RealmExpense.self))
    }
}
