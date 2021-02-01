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
        fpc.show(animated: true) {
            self.fpc.didMove(toParent: self)
        }
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
        newCategoryVC.closeButtonAction = { [unowned self] in
            fpc.willMove(toParent: nil)
            fpc.hide(animated: true)
        }
        fpc.set(contentViewController: newCategoryVC)
       
        self.view.addSubview(fpc.view)
        fpc.view.frame = self.view.bounds

        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          fpc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])

        self.addChild(fpc)

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
    
    var closeButtonAction: (() -> ())?
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        closeButtonAction?();
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
    }
    
    @IBOutlet weak var categoryTextField: UITextField!
}

