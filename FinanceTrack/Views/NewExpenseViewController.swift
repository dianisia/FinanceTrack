import UIKit
import RealmSwift
import PanModal

class NewExpenseViewController: UIViewController {
    
    struct Constants {
        static let viewHeight = 600
        static let viewMaxHeightWithTopInset = 40
    }
    
    var closePanel: (() -> ())?
    var categories: [Category] = []
    private var selectedCategoryIndex = -1;
    private var expensesViewModel = ExpensesViewModel()
    
    @IBOutlet weak var categoryDropdown: UIPickerView!
    @IBOutlet weak var reduceExpenseButton: UIButton!
    @IBOutlet weak var enlargeExpenseButton: UIButton!
    @IBOutlet weak var expenseTextInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var currentExpense = 500;
    
    @IBAction func onAddNewCategoryTap(_ sender: Any) {
        let newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as! NewCategoryViewController
        presentPanModal(newCategoryVC)
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        closePanel?()
        expenseTextInput.endEditing(true)
    }
    
    @IBAction func onAddExpense(_ sender: Any) {
        if selectedCategoryIndex == -1 {
            return
        }
        let date = datePicker.date
        expensesViewModel.addNewExpense(amount: Int(expenseTextInput.text ?? "") ?? 0, categoryId: String(selectedCategoryIndex), date: date, info: "zz")
        closePanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeExpenseButton(button: reduceExpenseButton)
        customizeExpenseButton(button: enlargeExpenseButton)
        expenseTextInput.text = String(currentExpense)
        expenseTextInput.becomeFirstResponder()
        expenseTextInput.keyboardType = UIKeyboardType.decimalPad
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

extension NewExpenseViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(Constants.viewHeight))
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(CGFloat(Constants.viewMaxHeightWithTopInset))
    }
    
    func panModalDidDismiss() {
        closePanel?()
    }
}

extension NewExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.capacity
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int) -> String? {
        self.view.endEditing(true)
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryIndex = row
    }
}
