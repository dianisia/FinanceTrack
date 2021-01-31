import UIKit
import RealmSwift

class CurrentBalance: Object {
    @objc dynamic var value = 0;
}

class Category: Object {
    @objc dynamic var name = ""
}

class ViewController: UIViewController {
    static let realm = try! Realm()
    private var categories: [Category] = [];
    private var currentBalance = 0;
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBalanceLabel.text = "100500"
        self.categories = Array(ViewController.realm.objects(Category.self));
        
        let category = Category();
        category.name = "Продукты"
        
        try! ViewController.realm.write {
            ViewController.realm.add(category);
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoriesTableViewCell;
        cell.categoryNameLabel.text = String(self.categories[indexPath.row].name);
        return cell;
    }
    
    
}

