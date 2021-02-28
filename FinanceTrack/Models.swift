import Foundation
import RealmSwift

class CurrentBalance: Object {
    @objc dynamic var value = 0
}

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var colorIndex = 0;
}
