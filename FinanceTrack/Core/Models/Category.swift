import Foundation

protocol CategoryProtocol {
    var categoryId: String { get }
    var name: String { get }
    var colorIndex: Int { get }
}

struct Category: CategoryProtocol {
    var categoryId: String = ""
    var name: String = ""
    var colorIndex: Int = 0
    
    init(realmCategory: RealmCategory) {
        self.categoryId = realmCategory.categoryId
        self.name = realmCategory.name
        self.colorIndex = realmCategory.colorIndex
    }
    
    init() {
        self.categoryId = ""
        self.name = ""
        self.colorIndex = 0
    }
}

