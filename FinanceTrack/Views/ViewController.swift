import UIKit
import RealmSwift
import Charts
import PanModal

protocol AddNewCategoryDelegate {
    func addNewCategory(categoryName: String, colorIndex: Int);
}

protocol AddNewExpenseDelegate {
    func addNewExpense(amount: Int, category: Category, date: Date, info: String)
}

class ViewController: UIViewController {
    private var categories: [Category] = []
    private var currentBalance = 0
    private var categoriesViewModel = CategoriesViewModel()
    private var expensesViewModel = ExpensesViewModel()
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
        
    var newCategoryVC: NewCategoryViewController!
    var newExpenseVC: NewExpenseViewController!
    var allExpensesVC: AllExpensesViewController!
    
        
    @IBAction func onShowNewExpensesTap(_ sender: Any) {
        openAllExpensesPanel()
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
        self.categories = categoriesViewModel.categories
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
        newExpenseVC.closePanel = updateData
        newExpenseVC.addNewExpenseDelegate = self
        
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
//        newCategoryVC.closePanel = closePanel
        newCategoryVC.addNewCategoryDelegate = self
        
        allExpensesVC = storyboard?.instantiateViewController(withIdentifier: "allExpenses") as? AllExpensesViewController
//        allExpensesVC.closePanel = closePanel
//        allExpensesVC.addNewCategoryDelegate = self
    }
    
    func openNewCategoryPanel() {

    }
    
    func openNewExpensePanel() {
        newExpenseVC.categories = self.categories
        presentPanModal(newExpenseVC)
    }
    
    func openAllExpensesPanel() {
        presentPanModal(allExpensesVC)
    }
    
    func updateData() {
        self.categories = categoriesViewModel.categories
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
        categoriesViewModel.addNewCategory(name: categoryName, colorIndex: colorIndex)
        categoriesTableView.reloadData()
    }
}

extension ViewController: AddNewExpenseDelegate {
    func addNewExpense(amount: Int, category: Category, date: Date, info: String) {
        expensesViewModel.addNewExpense(amount: amount, categoryId: "", date: date, info: info)
    }
}
