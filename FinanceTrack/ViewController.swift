import UIKit
import RealmSwift
import FloatingPanel
import Charts

class MyFloatingLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .safeArea),
            .half: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0.5, referenceGuide: .safeArea),
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
            case .full, .half: return 0.3
            default: return 0.0
        }
    }
}

protocol AddNewCategoryDelegate {
    func addNewCategory(categoryName: String, colorIndex: Int);
}

protocol AddNewExpenseDelegate {
    func addNewExpense(amount: Int, category: Category, date: Date)
}

class ViewController: UIViewController, FloatingPanelControllerDelegate {
    let realm = try! Realm()
    private var categories: [Category] = []
    private var currentBalance = 0
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    
    var newCategoryFCP: FloatingPanelController!
    var newExpenseFCP: FloatingPanelController!
    var fpc = FloatingPanelController()
    
    var newCategoryVC: NewCategoryViewController!
    var newExpenseVC: NewExpenseViewController!
    
    @IBAction func onAddNewCategoryTap(_ sender: Any) {
        openNewCategoryPanel()
    }
    
    @IBAction func onAddNewExpenseTap(_ sender: Any) {
        openNewExpensePanel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeView.layer.cornerRadius = 16
        addIncomeButton.layer.cornerRadius = 8
        addExpenseButton.layer.cornerRadius = 8
        
        currentBalanceLabel.text = "100500"
        self.categories = Array(realm.objects(Category.self))
        initViews()
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
        let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0]
        
        barChartView.noDataText = "No data"
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;

        let xaxis = barChartView.xAxis
        let formatter = CustomLabelsXAxisValueFormatter()
        formatter.labels = months
        xaxis.valueFormatter = formatter
        
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.axisLineColor = UIColor.white
        xaxis.granularityEnabled = true
        xaxis.enabled = true
        
        xaxis.granularity = 1

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        barChartView.rightAxis.enabled = false
        
        customizeChart(periods: months, data: [unitsSold, unitsBought])
    }
    
    func initViews() {
        newExpenseVC = storyboard?.instantiateViewController(identifier: "newExpense") as? NewExpenseViewController
        newExpenseVC.closePanel = closePanel
        newExpenseVC.addNewExpenseDelegate = self
        
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        newCategoryVC.closePanel = closePanel
        newCategoryVC.addNewCategoryDelegate = self
    }
    
    func openNewCategoryPanel() {
        initNewCategoryPanel(controller: newCategoryVC)
    }
    
    func openNewExpensePanel() {
        newExpenseVC.categories = self.categories
        initNewCategoryPanel(controller: newExpenseVC)
    }
        
    func closePanel() {
        fpc.willMove(toParent: nil)
        fpc.hide(animated: true)
    }
    
    //TODO: Refactor it
    func initNewCategoryPanel(controller: UIViewController) {
        fpc.delegate = self
        fpc.layout = MyFloatingLayout()
        fpc.surfaceView.appearance.cornerRadius = 24.0
        fpc.set(contentViewController: controller)
        fpc.panGestureRecognizer.isEnabled = false
        fpc.isRemovalInteractionEnabled = false
       
        self.view.addSubview(fpc.view)
        fpc.view.frame = self.view.bounds

        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          fpc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        
        fpc.show(animated: true) {
            self.fpc.didMove(toParent: self)
        }
    }
    
    func updateData() {
        self.categories = Array(realm.objects(Category.self))
        categoriesTableView.reloadData()
    }
    
    func customizeChart(periods: [String], data: [[Double]]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
    
        for i in 0..<periods.count {
            var yValues: [Double] = []
            for j in 0..<data.count {
                yValues.append(data[j][i])
            }
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  yValues, data: "groupChart")
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Unit sold")
       
        let dataSets: [BarChartDataSet] = [chartDataSet]
        chartDataSet.colors = ChartColorTemplates.colorful()

        let chartData = BarChartData(dataSets: dataSets)

        let groupSpace = 0.8
        let barSpace = 0.01
        let barWidth = 0.2
 
        chartData.barWidth = barWidth
        
        barChartView.xAxis.axisMinimum = 0.0
        barChartView.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(periods.count)
        chartData.groupBars(fromX: 0.2, groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        
        barChartView.xAxis.granularity = barChartView.xAxis.axisMaximum / Double(periods.count)

        barChartView.data = chartData

        //background color
        barChartView.backgroundColor = UIColor.white

        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}

class CustomLabelsXAxisValueFormatter : NSObject, IAxisValueFormatter {
    var labels: [String] = []
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        guard let axis = axis, count > 0 else {
            return ""
        }

        let factor = axis.axisMaximum / Double(count)
        let index = Int((value / factor).rounded())
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoriesTableViewCell
        cell.categoryNameLabel.text = String(self.categories[indexPath.row].name)
        cell.iconBackUIView.backgroundColor = Helper.UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[self.categories[indexPath.row].colorIndex]))
        return cell
    }
}

extension ViewController: AddNewCategoryDelegate {
    func addNewCategory(categoryName: String, colorIndex: Int) {
        let category = Category()
        category.name = categoryName
        category.colorIndex = colorIndex
        try! realm.write {
           realm.add(category)
        }
        updateData()
    }
}

extension ViewController: AddNewExpenseDelegate {
    func addNewExpense(amount: Int, category: Category, date: Date) {
        let expense = Expense()
        expense.amount = amount
        expense.category = category
        expense.date = date
        try! realm.write {
            realm.add(expense)
        }
    }
}
