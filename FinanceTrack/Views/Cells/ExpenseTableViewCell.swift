import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var iconBackUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconBackUIView.layer.cornerRadius = iconBackUIView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
