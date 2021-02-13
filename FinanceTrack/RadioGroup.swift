import UIKit

class RadioGroupItem: UIView {
    
    let view = UIView()
    var isSelected: Bool = false
    var width: CGFloat = 40
    var height: CGFloat = 40
    var color: UIColor = UIColor.red
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    
    
    convenience init(color: UIColor, x: Int, y: Int, width: Int, height: Int) {
        self.init(frame: .zero)
        self.color = color
        self.x = CGFloat(x)
        self.y = CGFloat(y)
        self.width = CGFloat(width)
        self.height = CGFloat(height)
        setup()
    }
    
    private func setup() {
        frame = CGRect(x: x, y: y, width: width, height: height)
        backgroundColor = color
        layer.cornerRadius = 5
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class RadioGroup: UIControl {
    var selectedIndex: Int = -1
    
    private let stackView = UIStackView()
    private var items: [RadioGroupItem] = []
    private var colors: [UIColor] = []
    private let spacing = 10
    private let size = 40
    
    convenience init(colors: [UIColor]) {
        self.init(frame: .zero)
        self.colors = colors
        setup()
    }
    
    private func setup() {
        for i in 0..<self.colors.count {
            let item = RadioGroupItem(color: self.colors[i], x: i * (size + spacing), y: 0, width: size, height: size)
            stackView.addSubview(item)
        }
        addSubview(stackView)
    }
    
    public override init(frame: CGRect) {
       super.init(frame: frame)
   }

   public required init?(coder: NSCoder) {
       super.init(coder: coder)
   }
}
