import UIKit
import RealmSwift
import FloatingPanel

class CurrentBalance: Object {
    @objc dynamic var value = 0
}

class Category: Object {
    @objc dynamic var name = ""
}

class ViewController: UIViewController, FloatingPanelControllerDelegate {
    static let realm = try! Realm()
    private var categories: [Category] = []
    private var currentBalance = 0
    
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var newCategoryVC: NewCategoryViewController!
    
    @IBAction func onTap(_ sender: Any) {
        fpc.isRemovalInteractionEnabled = true
        self.present(fpc, animated: true, completion: nil)
    }
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.surfaceView.appearance.cornerRadius = 24.0
        
        currentBalanceLabel.text = "100500"
        self.categories = Array(ViewController.realm.objects(Category.self))
        
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        fpc.set(contentViewController: newCategoryVC)
        
        let category = Category()
        category.name = "Продукты"
        
//        try! ViewController.realm.write {
//            ViewController.realm.add(category)
//        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoriesTableViewCell
        cell.categoryNameLabel.text = String(self.categories[indexPath.row].name)
        return cell
    }
}

class NewCategoryViewController: UIViewController {
    
    @IBAction func onAddCategory(_ sender: Any) {
    }
    
    @IBOutlet weak var categoryTextField: UITextField!
}

