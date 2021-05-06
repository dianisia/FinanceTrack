import Foundation
import RealmSwift

class RealmIncome: Object {
    @objc dynamic var _amount = 0
    @objc dynamic var _date = Date()
}

extension RealmIncome: Income {
    var amount: Int { return _amount }
    var date: Date { return _date }
}

class RealmIncomesRepository: IncomesRepository {
    func listAll() -> [Income] {
        let realm = try! Realm()
        return Array(realm.objects(RealmIncome.self))
    }
    
    func add(amount: Int, date: Date) {
        let realm = try! Realm()
        let income = RealmIncome()
        income._amount = amount
        income._date = date.trimTime()
        try! realm.write {
            realm.add(income)
        }
    }
    
    func getTotal(for period: Period) -> Double {
        listAll()
            .filter{ Helper.checkDateIsInPeriod(date: $0.date, period: period) }
            .reduce(0) { $0 + Double($1.amount) }
    }
}
