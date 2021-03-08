import Foundation
import RealmSwift

class CurrentBalance: Object {
    @objc dynamic var value = 0
}

class Category: Object {
    @objc dynamic var categoryId = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var colorIndex = 0
    
    override class func primaryKey() -> String? {
        return "categoryId"
    }
}

class Expense: Object {
    @objc dynamic var amount = 0
    @objc dynamic var category: Category?
    @objc dynamic var date = Date()
}
