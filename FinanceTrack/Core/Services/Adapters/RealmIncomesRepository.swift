import Foundation
import RealmSwift

class RealmIncome: Object {
    @objc dynamic var _amount = 0.0
    @objc dynamic var _date = Date()
}

extension RealmIncome: Income {
    var amount: Double { return _amount }
    var date: Date { return _date }
}

class RealmIncomesRepository: IncomesRepository {
    private let realm = try! Realm()
    
    func listAll() -> [Income] {
        return Array(realm.objects(RealmIncome.self))
    }
    
    func listAll(period: Period) -> [Income] {
        let interval = Helper.getDateInterval(period: period)
        return Array(realm.objects(RealmIncome.self).filter("_date BETWEEN %@", [interval.finish, interval.start]))
    }
    
    func add(amount: Double, date: Date) {
        let income = RealmIncome()
        income._amount = amount
        income._date = date.trimTime()
        try? realm.write {
            realm.add(income)
        }
    }
    
    func getTotal(for period: Period) -> Double {
        listAll(period: period).reduce(0) { $0 + Double($1.amount) }
    }
}
