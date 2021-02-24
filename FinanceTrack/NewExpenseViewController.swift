import UIKit

class NewExpenseViewController: UIViewController {

    @IBOutlet weak var reduceExpenseButton: UIButton!
    @IBOutlet weak var enlargeExpenseButton: UIButton!
    
    @IBOutlet weak var expenseLabel: UILabel!
    
    private var currentExpense = 500;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeExpenseButton(button: reduceExpenseButton)
        customizeExpenseButton(button: enlargeExpenseButton)
        expenseLabel.text = String(currentExpense)
    }
    
    func customizeExpenseButton(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Helper.UIColorFromHex(rgbValue: 0xEAEAF2).cgColor
        button.layer.cornerRadius = 10
    }
    
    
    @IBAction func onReduceTap(_ sender: Any) {
        currentExpense -= 1
        expenseLabel.text = String(currentExpense)
    }
    
    
    @IBAction func onEnlargeTap(_ sender: Any) {
        currentExpense += 1
        expenseLabel.text = String(currentExpense)
    }
    
}
