import UIKit
import Charts
import PanModal

class CategoryExpensesViewController: UIViewController, BarChartDrawable {
    
    struct DefConstants {
        static let viewHeight = 750
        static let viewMaxHeightWithTopInset = 40
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var expensesTableView: UITableView!
    
    private var graphData = GraphData(labels: [], data: [])
    private var expenses: GroupedExpenses = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChart()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setChartData(labels: graphData.labels, data: graphData.data)
        expensesTableView.reloadData()
    }
    
    func configure(with viewModel: CategoryExpensesViewModel) {
        self.graphData = viewModel.prepareGraphData(period: .week)
        self.expenses = viewModel.getExpensesForPeriod(period: .week)
    }
}

extension CategoryExpensesViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(DefConstants.viewHeight))
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(CGFloat(DefConstants.viewMaxHeightWithTopInset))
    }
    
    func panModalDidDismiss() {
        //closePanel?()
    }
}

extension CategoryExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Array(expenses)[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as? ExpenseTableViewCell
        if cell == nil {
            cell = ExpenseTableViewCell.createCell()!
        }
        let currExpense: Expense = Array(expenses)[indexPath.section].value[indexPath.row]
        cell?.updateWith(
            expense: " \(currExpense.category.name) \(currExpense.info)",
            categoryColor: Helper
                .UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[currExpense.category.colorIndex])),
            amount: currExpense.amount
        )
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenses.values.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Array(expenses)[section].key.monthDateFormate()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = .white
            header.textLabel?.textColor = .black
        }
    }
}
