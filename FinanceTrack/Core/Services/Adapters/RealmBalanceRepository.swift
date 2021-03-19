import Foundation
import RealmSwift

class RealmBalance: Object {
    @objc dynamic var r_value = 0
}

class RealmBalanceRepository: BalanceRepository {
    func get() -> Double {
        return 10500;
    }
}
