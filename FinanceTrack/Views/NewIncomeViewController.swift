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
    }
    
    @IBAction func onEnlargeTap(_ sender: Any) {
        currentIncome += 1
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