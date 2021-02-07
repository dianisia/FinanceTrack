import UIKit
import RealmSwift
import FloatingPanel

class CurrentBalance: Object {
    @objc dynamic var value = 0
}

class Category: Object {
    @objc dynamic var name = ""
}

protocol AddNewCategoryDelegate {
    func addNewCategory(categoryName: String);
}

class ViewController: UIViewController, FloatingPanelControllerDelegate {
    let realm = try! Realm()
    private var categories: [Category] = []
    private var currentBalance = 0
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    
    var newCategoryVC: NewCategoryViewController!
    var fpc: FloatingPanelController!
    
    @IBAction func onTap(_ sender: Any) {
        openPanel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeView.layer.cornerRadius = 16
        addIncomeButton.layer.cornerRadius = 8
        addExpenseButton.layer.cornerRadius = 8
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.surfaceView.appearance.cornerRadius = 24.0
        
        currentBalanceLabel.text = "100500"
        self.categories = Array(realm.objects(Category.self))
        initPanel()
    }
    
    func openPanel() {
        fpc.show(animated: true) {
            self.fpc.didMove(toParent: self)
        }
    }
    
    func closePanel() {
        fpc.willMove(toParent: nil)
        fpc.hide(animated: true)
    }
    
    func initPanel() {
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        newCategoryVC.closePanel = closePanel
        newCategoryVC.addNewCategoryDelegate = self
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
    }
    
    func updateData() {
        self.categories = Array(realm.objects(Category.self))
        categoriesTableView.reloadData()
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

extension ViewController: AddNewCategoryDelegate {
    func addNewCategory(categoryName: String) {
        let category = Category()
        category.name = categoryName
        try! realm.write {
           realm.add(category)
        }
        updateData()
    }
}

class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    var closePanel: (() -> ())?
    var addNewCategoryDelegate: AddNewCategoryDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryNameTextField.delegate = self
        addButton.isUserInteractionEnabled = false
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        closePanel?()
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
        guard let categoryName = categoryNameTextField.text, !categoryName.isEmpty else {
            return
        }
        addNewCategoryDelegate?.addNewCategory(categoryName: categoryName)
        categoryNameTextField.text = ""
        closePanel?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !text.isEmpty{
            addButton.isUserInteractionEnabled = true
        } else {
            addButton.isUserInteractionEnabled = false
        }

        return true
    }
}

