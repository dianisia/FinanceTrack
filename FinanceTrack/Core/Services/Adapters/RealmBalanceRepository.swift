import Foundation
import RealmSwift

class RealmBalance: Object {
    @objc static let uniqueKey = "balanceKey"
    
    @objc dynamic var _value: Double = 0
    @objc dynamic var uniqueKey: String = RealmBalance.uniqueKey
    
    override class func primaryKey() -> String? {
        return "uniqueKey"
    }
}

extension RealmBalance: Balance {
    var value: Double { return _value }
}

class RealmBalanceRepository: BalanceRepository {
    func get() -> Double {
        let realm = try! Realm()
        let key = RealmBalance.uniqueKey
        return realm.object(ofType: RealmBalance.self, forPrimaryKey: key)?._value ?? 0
    }
    
    func create(amount: Double) {
        let realm = try! Realm()
        let balance = RealmBalance()
        balance._value = amount
        try! realm.write {
            realm.add(balance)
        }
    }
    
    func add(amount: Double) {
        updateValue(amount: amount)
    }
    
    func substract(amount: Double) {
        updateValue(amount: -amount)
    }
    
    private func updateValue(amount: Double) {
        let realm = try! Realm()
        let currBalance = realm.object(ofType: RealmBalance.self, forPrimaryKey: RealmBalance.uniqueKey)
        if (currBalance != nil) {
            try! realm.write {
                currBalance!._value += amount
            }
        }
        else {
            create(amount: amount)
        }
    }
}
