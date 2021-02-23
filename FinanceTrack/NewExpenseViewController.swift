import UIKit

class NewExpenseViewController: UIViewController {

    @IBOutlet weak var reduceExpenseButton: UIButton!
    @IBOutlet weak var enlargeExpenseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeExpenseButton(button: reduceExpenseButton)
        customizeExpenseButton(button: enlargeExpenseButton)
    }
    
    func customizeExpenseButton(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Helper.UIColorFromHex(rgbValue: 0xEAEAF2).cgColor
        button.layer.cornerRadius = 10
    }
    
}
