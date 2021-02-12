import UIKit

class RadioGroupItem: UIView {
    
    let view = UIView()
    var isSelected: Bool = false
    var width: CGFloat = 40
    var height: CGFloat = 40
    var color: UIColor = UIColor.red
    
    private func setup() {
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backgroundColor = color
        layer.cornerRadius = 5
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class RadioGroup: UIControl {
    var selectedIndex: Int = -1
    
    private let stackView = UIStackView()
    private var items: [RadioGroupItem] = []
    var colors: [UIColor] {
        get {
            return items.map { $0.color }
        }
        set {
            stackView.addArrangedSubview(newValue.map {RadioGroupItem(color: $0)})
        }
    }
    
    private func setup() {
        let categoryColors = [
            Helper.UIColorFromHex(rgbValue: 0x47D124),
            Helper.UIColorFromHex(rgbValue: 0x7DC9FF),
            Helper.UIColorFromHex(rgbValue: 0xFF7EEA),
            Helper.UIColorFromHex(rgbValue: 0xC190FF),
            Helper.UIColorFromHex(rgbValue: 0xFF7171),
            Helper.UIColorFromHex(rgbValue: 0xFFCE85),
            Helper.UIColorFromHex(rgbValue: 0x24D1C7)
        ]
        
        for i in 0..<categoryColors.capacity {
            let greenView = ColorItemView()
            greenView.isChecked = true
            greenView.frame = CGRect(x: i * (40 + 10) + 10, y: 0, width: 40, height: 40)
            greenView.backgroundColor = categoryColors[i]
            greenView.layer.cornerRadius = 5
            
            stackView.addSubview(greenView)
        }
        
        addSubview(stackView)
    }
    
    public override init(frame: CGRect) {
       super.init(frame: frame)
       setup()
   }

   public required init?(coder: NSCoder) {
       super.init(coder: coder)
       setup()
   }
}
