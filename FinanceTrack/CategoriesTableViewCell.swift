import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var iconBackUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconBackUIView.layer.cornerRadius = iconBackUIView.frame.width / 2
        iconBackUIView.layer.cornerRadius = 7
        iconBackUIView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
