import UIKit
import iOSDropDown
import RealmSwift

class ExpenseView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 414, height: 700)
    }
}

class NewExpenseViewController: UIViewController {
    var closePanel: (() -> ())?
    var categories: [Category] = []
    var addNewExpenseDelegate: AddNewExpenseDelegate?
    private var selectedCategoryIndex = -1;
    
    @IBOutlet weak var reduceExpenseButton: UIButton!
    @IBOutlet weak var enlargeExpenseButton: UIButton!
    @IBOutlet weak var expenseTextInput: UITextField!
    @IBOutlet weak var categoryDropdown: DropDown!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var currentExpense = 500;
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        closePanel?()
        expenseTextInput.endEditing(true)
    }
    
    @IBAction func onAddExpense(_ sender: Any) {
        if selectedCategoryIndex == -1 {
            return
        }
        let date = datePicker.date
        addNewExpenseDelegate?.addNewExpense(amount: currentExpense, category: self.categories[selectedCategoryIndex], date: date, info: "zz")
        closePanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeExpenseButton(button: reduceExpenseButton)
        customizeExpenseButton(button: enlargeExpenseButton)
        expenseTextInput.text = String(currentExpense)
        expenseTextInput.becomeFirstResponder()
        expenseTextInput.keyboardType = UIKeyboardType.decimalPad
        
        categoryDropdown.listWillAppear {
            self.categoryDropdown.optionArray = Array(self.categories).map {$0.name}
        }
        
        categoryDropdown.didSelect {(selectedText, index, id) in
            self.selectedCategoryIndex = index
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        expenseTextInput.becomeFirstResponder()
    }
    
    func customizeExpenseButton(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Helper.UIColorFromHex(rgbValue: 0xEAEAF2).cgColor
        button.layer.cornerRadius = 10
    }
    
    
    @IBAction func onReduceTap(_ sender: Any) {
        currentExpense -= 1
        expenseTextInput.text = String(currentExpense)
    }
    
    
    @IBAction func onEnlargeTap(_ sender: Any) {
        currentExpense += 1
        expenseTextInput.text = String(currentExpense)
    }
    
}
