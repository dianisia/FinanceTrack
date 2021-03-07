import UIKit

class CategoryView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 414, height: 350)
    }
}

class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    var closePanel: (() -> ())?
    var addNewCategoryDelegate: AddNewCategoryDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var colorsScrollView: UIScrollView!
    @IBOutlet weak var colorsView: UIView!
 
    let categoryColorRG = RadioGroup(colors: Constants.categoryColors.map { Helper.UIColorFromHex(rgbValue: UInt32($0))})
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryNameTextField.delegate = self
        addButton.isUserInteractionEnabled = false
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: categoryNameTextField.frame.height - 1, width: categoryNameTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        categoryNameTextField.borderStyle = UITextField.BorderStyle.none
        categoryNameTextField.layer.addSublayer(bottomLine)
                
        colorsView.addSubview(categoryColorRG)
        categoryColorRG.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint(item: categoryColorRG,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: colorsView,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: categoryColorRG,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: colorsView,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: categoryColorRG,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: colorsView,
                           attribute: .width,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: categoryColorRG,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: colorsView,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: 0).isActive = true
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        closePanel?()
    }
    
    @IBAction func onAddCategory(_ sender: Any) {
        guard let categoryName = categoryNameTextField.text, !categoryName.isEmpty else {
            return
        }
        
        addNewCategoryDelegate?.addNewCategory(categoryName: categoryName, colorIndex: categoryColorRG.selectedIndex)
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
