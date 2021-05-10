import UIKit
import RealmSwift
import PanModal

class NewIncomeViewController: UIViewController {
    
    struct Constants {
        static let viewHeight = 600
        static let viewMaxHeightWithTopInset = 40
    }
    
    var closePanel: (() -> ())?
    private var incomesViewModel = IncomesViewModel()
    @IBOutlet weak var incomeTextInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var currentIncome = 500;

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func customizeExpenseButton(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Helper.UIColorFromHex(rgbValue: 0xEAEAF2).cgColor
        button.layer.cornerRadius = 10
    }
    
    @IBAction func onReduceTap(_ sender: Any) {
        currentIncome -= 1
        incomeTextInput.text = String(currentIncome)
    }
    
    @IBAction func onEnlargeTap(_ sender: Any) {
        currentIncome += 1
        incomeTextInput.text = String(currentIncome)
    }
    
    @IBAction func onAddIncome(_ sender: Any) {
        let date = datePicker.date
        incomesViewModel.addNewIncome(amount: Double(incomeTextInput.text ?? "") ?? 0, date: date)
        closePanel?()
    }
    
}

extension NewIncomeViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(CGFloat(Constants.viewHeight))
    }

    var longFormHeight: PanModalHeight {
        .maxHeightWithTopInset(CGFloat(Constants.viewMaxHeightWithTopInset))
    }
    
    func panModalDidDismiss() {
        closePanel?()
    }
}
