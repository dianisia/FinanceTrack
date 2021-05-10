import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var iconBackUIView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconBackUIView.layer.cornerRadius = iconBackUIView.frame.width / 2
    }
    
    class func createCell() -> ExpenseTableViewCell? {
        let nib = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        let cell = nib.instantiate(withOwner: self, options: nil).last as? ExpenseTableViewCell
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateWith(expense: String, categoryColor: UIColor, amount: Double) {
        expenseLabel.text = expense
        amountLabel.text = Helper.formateExpense(amount: amount)
        iconBackUIView.backgroundColor = categoryColor
    }
    
}
