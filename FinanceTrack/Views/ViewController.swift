import UIKit
import RealmSwift
import Charts
import PanModal

struct GraphData {
    var labels: [String]
    var data: [Double]
}

class ViewController: UIViewController, BarChartDrawable {
    private var categories: [TotalExpenseForCategory] = []
    private var currentBalance = 0
    
    private var categoriesViewModel = CategoriesViewModel()
    private var expensesViewModel = ExpensesViewModel()
    private var incomesViewModel = IncomesViewModel()
    private var balanceViewModel = BalanceViewModel()
    
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var showExpensesButton: UIButton!
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
    var categoryExpensesVC: CategoryExpensesViewController!
    
    private var currentPeriod: Period = .week
    
    @IBAction func onShowNewExpensesTap(_ sender: Any) {
        presentPanModal(allExpensesVC)
    }
    
    @IBAction func onAddNewIncomeTap(_ sender: Any) {
        presentPanModal(newIncomeVC)
    }
    
    @IBAction func onAddNewExpenseTap(_ sender: Any) {
        presentPanModal(newExpenseVC)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeView.layer.cornerRadius = 16
        addIncomeButton.layer.cornerRadius = 8
        addExpenseButton.layer.cornerRadius = 8
        currentPeriod = .week
        periodsSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        initViews()
        updateIncomes()
        updateCategories()
        customizeChart()
        updateGraph()
        updateCurrentBalance()
    }
    
    func updateGraph() {
        expensesViewModel.getTotalForDate(period: currentPeriod) {[unowned self] (groupedData: [TotalExpenseForDate]) -> Void in
            let data: [Double] = groupedData.map { $0.amount }
            let graphData = GraphData(labels: groupedData.map { $0.date.monthDateFormate() } , data: data)
            if (graphData.data.count > 0) {
                self.setChartData(labels: graphData.labels, data: graphData.data)
            }
        }
    }
    
    func initViews() {
        newExpenseVC = storyboard?.instantiateViewController(identifier: "newExpense") as? NewExpenseViewController
        newExpenseVC.closePanel = { [weak self] in
            self?.updateCategories()
            self?.updateGraph()
            self?.updateCurrentBalance()
        }
        
        newCategoryVC = storyboard?.instantiateViewController(withIdentifier: "newCategory") as? NewCategoryViewController
        
        allExpensesVC = storyboard?.instantiateViewController(withIdentifier: "allExpenses") as? AllExpensesViewController
        
        newIncomeVC = storyboard?.instantiateViewController(withIdentifier: "newIncome") as? NewIncomeViewController
        newIncomeVC.closePanel = updateIncomes
        
        categoryExpensesVC = storyboard?.instantiateViewController(withIdentifier: "categoryExpenses") as? CategoryExpensesViewController
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
        updateCategories()
    }
    
    private func updateCategories() {
        expensesViewModel.getTotalForCategory(period: currentPeriod) { [unowned self] (categories: [TotalExpenseForCategory]) -> Void in
            self.categories = categories
            self.categoriesTableView.reloadData()
            self.showExpensesButton.isHidden = self.categories.count == 0
        }
    }
    
    private func updateIncomes() {
        totalIncomeLabel.text = String(incomesViewModel.getTotal(for: currentPeriod).removeZerosFromEnd())
        let periods = Helper.getLastDays(for: currentPeriod)
        incomeStartDateLabel.text = String(periods[0].monthDateFormate())
        incomeFinishDateLabel.text = String(periods[periods.count-1].monthDateFormate())
        updateCurrentBalance()
    }
    
    private func updateCurrentBalance() {
        currentBalanceLabel.text = Helper.formateExpense(amount: balanceViewModel.get())
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as? ExpenseTableViewCell
        if cell == nil {
            cell = ExpenseTableViewCell.createCell()!
        }
        let category = categories[indexPath.row].category
        cell?.updateWith(
            expense: category.name,
            categoryColor: Helper.UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[category.colorIndex])),
            amount: categories[indexPath.row].amount)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryExpensesVC.configure(with: CategoryExpensesViewModel(category: categories[indexPath.row].category))
        presentPanModal(categoryExpensesVC)
    }
}
