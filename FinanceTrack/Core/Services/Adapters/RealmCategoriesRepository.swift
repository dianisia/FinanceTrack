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

extension RealmCategory: CategoryProtocol {
    var categoryId: String { return  _categoryId}
    var name: String { return _name }
    var colorIndex: Int { return _colorIndex }
}

class RealmCategoriesRepository: CategoriesRepository {
    private let realm = try! Realm()
    
    func getForId(categoryId: String) -> RealmCategory {
        //TODO: Fix !
        return realm.object(ofType: RealmCategory.self, forPrimaryKey: categoryId)!
    }
    
    func listAll() -> [Category] {
        return Array(realm.objects(RealmCategory.self))
            .map {Category(realmCategory: $0)}
    }
    
    func add(name: String, colorIndex: Int) {
        let category = RealmCategory()
        category._name = name
        category._colorIndex = colorIndex
        try? realm.write {
           realm.add(category)
        }
    }
    
    func getColor(id: String) -> Int {
        getForId(categoryId: id).colorIndex
    }
}
