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

struct CategoryExpenseGraphData {
    var color: UIColor
    var amount: Int
}

struct GraphData {
    var labels: [String]
    var data: [[CategoryExpenseGraphData]]
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
    var newIncomeVC: NewIncomeViewController!
    
        
    @IBAction func onShowNewExpensesTap(_ sender: Any) {
        openAllExpensesPanel()
    }
    
    @IBAction func onAddNewIncomeTap(_ sender: Any) {
        openNewIncomePanel()
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
    
        let graphData = prepareGraphData()
        
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
        formatter.labels = graphData.labels
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
                 
        customizeChart(labels: graphData.labels, data: graphData.data)
    }
    
    func prepareGraphData() -> GraphData {
        let groupedData = expensesViewModel.getTotalPeriod(period: .week)
        var data: [[CategoryExpenseGraphData]] = []

        groupedData.values.forEach { value in
            var categoryData: [CategoryExpenseGraphData] = []
            for (categoryId, amount) in value {
                let colorIndex = categoriesViewModel.getColorForCategory(id: categoryId)
                categoryData.append(
                    CategoryExpenseGraphData(
                        color: Helper.UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[colorIndex])),
                        amount: amount
                    ))
            }
            data.append(categoryData)
        }
        return GraphData(labels: groupedData.keys.map{ $0 }, data: data)
    }
    
    func initViews() {
        newExpenseVC = storyboard?.instantiateViewController(identifier: "newExpense") as? NewExpenseViewController
        newExpenseVC.closePanel = updateData
    
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        
        allExpensesVC = storyboard?.instantiateViewController(withIdentifier: "allExpenses") as? AllExpensesViewController
        
        newIncomeVC = storyboard?.instantiateViewController(withIdentifier: "newIncome") as? NewIncomeViewController
    }
    
    func openNewCategoryPanel() {

    }
    
    func openNewIncomePanel() {
        presentPanModal(newIncomeVC)
    }
    
    func openNewExpensePanel() {
        presentPanModal(newExpenseVC)
    }
    
    func openAllExpensesPanel() {
        presentPanModal(allExpensesVC)
    }
    
    func updateData() {
        categories = categoriesViewModel.categories
        categoriesTableView.reloadData()
    }
    
    func customizeChart(labels: [String], data: [[CategoryExpenseGraphData]]) {
        barChartView.noDataText = "Нет данных для отображения"
        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<labels.count {
            let yValues: [Double] = data[i].map{ Double($0.amount) }
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  yValues, data: "groupChart")
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Категории трат")
        
        
        chartDataSet.colors = []
        for i in 0..<data.count {
            for j in 0..<data[i].count {
                chartDataSet.colors.append(data[i][j].color)
            }
        }
        
        let dataSets: [BarChartDataSet] = [chartDataSet]
        let chartData = BarChartData(dataSets: dataSets)

        let groupSpace = 0.2
        let barSpace = 0.0
        let barWidth = 0.5
 
        chartData.barWidth = barWidth
        
        barChartView.xAxis.axisMinimum = 0.0
        barChartView.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(labels.count)
        chartData.groupBars(fromX: 0.5, groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        
        barChartView.xAxis.granularity = barChartView.xAxis.axisMaximum / Double(labels.count)

        barChartView.data = chartData

        //background color
        barChartView.backgroundColor = UIColor.white

        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    private func colorsOfCharts() -> [UIColor] {
        Constants.categoryColors.map {Helper.UIColorFromHex(rgbValue: UInt32($0))}
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
        cell.categoryNameLabel.text = String(categories[indexPath.row].name)
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
