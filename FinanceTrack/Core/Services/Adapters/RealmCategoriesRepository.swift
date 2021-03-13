import Foundation
import RealmSwift

class RealmCategory: Object {
    @objc dynamic var _categoryId = UUID().uuidString
    @objc dynamic var _name = ""
    @objc dynamic var _colorIndex = 0

    override class func primaryKey() -> String? {
        return "_categoryId"
    }
}

extension RealmCategory: Category {
    var categoryId: String { return  _categoryId}
    var name: String { return _name }
    var colorIndex: Int { return _colorIndex }
    
}

class RealmCategoriesRepository: CategoriesRepository {
    func listAll() -> [Category] {
        let realm = try! Realm()
        return Array(realm.objects(RealmCategory.self))
    }
    
    func add(name: String, colorIndex: Int) {
        let realm = try! Realm()
        let category = RealmCategory()
        category._name = name
        category._colorIndex = colorIndex
        try! realm.write {
           realm.add(category)
        }
        
    }
}
