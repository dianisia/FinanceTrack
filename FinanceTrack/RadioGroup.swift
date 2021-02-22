import UIKit

class RadioGroup: UIControl {
    var selectedIndex: Int = 0 {
        didSet {
            items[oldValue].isSelected = false
            items[selectedIndex].isSelected = true
        }
    }
    
    private let stackView = UIStackView()
    private var items: [RadioGroupItem] = []
    private var colors: [UIColor] = []
    private let spacing = 10
    private let size = 40
    
    convenience init(colors: [UIColor]) {
        self.init(frame: .zero)
        self.colors = colors
        setup()
        isUserInteractionEnabled = true
    }
    
    private func setup() {
        for i in 0..<self.colors.count {
            let item = RadioGroupItem(color: self.colors[i], x: i * (size + spacing), y: 0, width: size, height: size, group: self)
            items.append(item)
            stackView.addSubview(item)
        }
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: stackView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: stackView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: stackView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .width,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: stackView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
    }
    
    func selectIndex(item: RadioGroupItem) {
        guard let index = stackView.subviews.firstIndex(of: item) else {return}
        selectedIndex = index
    }
    
    public override init(frame: CGRect) {
       super.init(frame: frame)
   }

   public required init?(coder: NSCoder) {
       super.init(coder: coder)
   }
}

class RadioGroupItem: UIView {
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = Helper.UIColorFromHex(rgbValue: UInt32(Constants.selectedCategoryBorderColor)).cgColor
            } else {
                layer.borderWidth = 0
            }
        }
    }
    var width: CGFloat = 40
    var height: CGFloat = 40
    var color: UIColor = UIColor.red
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    
    unowned var group: RadioGroup = RadioGroup()
    
    convenience init(color: UIColor, x: Int, y: Int, width: Int, height: Int, group: RadioGroup) {
        self.init(frame: .zero)
        self.color = color
        self.x = CGFloat(x)
        self.y = CGFloat(y)
        self.width = CGFloat(width)
        self.height = CGFloat(height)
        self.group = group
        setup()
    }
    
    private func setup() {
        frame = CGRect(x: x, y: y, width: width, height: height)
        backgroundColor = color
        layer.cornerRadius = 5
        isUserInteractionEnabled = true
        isAccessibilityElement = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect)))
    }
    
    @objc func didSelect() {
        group.selectIndex(item: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

