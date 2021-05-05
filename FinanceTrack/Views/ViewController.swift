import UIKit
import RealmSwift
import Charts
import PanModal

struct GraphData {
    var labels: [String]
    var data: [Double]
}

class ViewController: UIViewController {
    private var categories: [Category] = []
    private var currentBalance = 0
    private var categoriesViewModel = CategoriesViewModel()
    private var expensesViewModel = ExpensesViewModel()
    private var incomesViewModel = IncomesViewModel()
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var incomeStartDateLabel: UILabel!
    @IBOutlet weak var incomeFinishDateLabel: UILabel!
    @IBOutlet weak var periodsSegmentedControl: UISegmentedControl!
    
    var newCategoryVC: NewCategoryViewController!
    var newExpenseVC: NewExpenseViewController!
    var allExpensesVC: AllExpensesViewController!
    var newIncomeVC: NewIncomeViewController!
    
    private var currentPeriod: Period = .week
    
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
        currentPeriod = .week
        
        periodsSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        currentBalanceLabel.text = "100500"
        self.categories = categoriesViewModel.categories
        initViews()
        updateIncomes()
        customizeChart()
        updateGraph()
    }
    
    func prepareGraphData(period: Period) -> GraphData {
        let groupedData = expensesViewModel.getTotalPeriod(period: period)
        let data: [Double] = groupedData.map { $0.amount }
        return GraphData(labels: groupedData.map { $0.date.monthDateFormate() } , data: data)
    }
    
    func initViews() {
        newExpenseVC = storyboard?.instantiateViewController(identifier: "newExpense") as? NewExpenseViewController
        newExpenseVC.closePanel = { [weak self] in
            self?.updateCategories()
            self?.updateGraph()
        }
        
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        
        allExpensesVC = storyboard?.instantiateViewController(withIdentifier: "allExpenses") as? AllExpensesViewController
        
        newIncomeVC = storyboard?.instantiateViewController(withIdentifier: "newIncome") as? NewIncomeViewController
        newIncomeVC.closePanel = updateIncomes
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch periodsSegmentedControl.selectedSegmentIndex {
        case 0:
            currentPeriod = .week
        case 1:
            currentPeriod = .month
        case 2:
            currentPeriod = .quarter
        default:
            currentPeriod = .allTime
        }
        updateGraph()
        updateIncomes()
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
    
    func updateCategories() {
        categories = categoriesViewModel.categories
        categoriesTableView.reloadData()
    }
    
    func updateIncomes() {
        totalIncomeLabel.text = String(incomesViewModel.getTotal())
        let periods = Helper.getLastDays(for: currentPeriod)
        incomeStartDateLabel.text = String(periods[0].monthDateFormate())
        incomeFinishDateLabel.text = String(periods[periods.count-1].monthDateFormate())
    }
    
    func updateGraph() {
        let graphData = prepareGraphData(period: currentPeriod)
        if (graphData.data.count > 0) {
            setChartData(labels: graphData.labels, data: graphData.data)
        }
    }
    
    private func setChartData(labels: [String], data: [Double]) {
        barChartView.noDataText = "Нет данных для отображения"
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<labels.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: data[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Сумма за день")
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.backgroundColor = UIColor.white
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        let xaxis = barChartView.xAxis
        let formatter = CustomLabelsXAxisValueFormatter()
        formatter.labels = labels
        xaxis.valueFormatter = formatter
    }
    
    private func customizeChart() {
        barChartView.noDataText = "No data"
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yEntrySpace = 0.0;
        
        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.axisLineColor = UIColor.white
        xaxis.granularityEnabled = true
        xaxis.enabled = true
        
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 10
        yaxis.drawGridLinesEnabled = false
        
        barChartView.rightAxis.enabled = false
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
