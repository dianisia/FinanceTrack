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
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    private var graphData = GraphData(labels: [], data: [])
    private var expenses: ExpensesForDate = [:]
    private var categoryName: String = ""
    private var dates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChart()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setChartData(labels: graphData.labels, data: graphData.data)
        expensesTableView.reloadData()
        categoryNameLabel.text = categoryName
    }
    
    func configure(with viewModel: CategoryExpensesViewModel) {
        graphData = viewModel.prepareGraphData(period: .week)
        expenses = viewModel.getExpensesForPeriod(period: .week)
        dates = Array(expenses.keys).sorted(by: <)
        categoryName = viewModel.getCategoryName()
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
        expenses[dates[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as? ExpenseTableViewCell
        if cell == nil {
            cell = ExpenseTableViewCell.createCell()!
        }
        let currExpense: Expense = expenses[dates[indexPath.section]]![indexPath.row]
        cell?.updateWith(
            expense: " \(currExpense.category.name) \(currExpense.info)",
            categoryColor: Helper
                .UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[currExpense.category.colorIndex])),
            amount: currExpense.amount
        )
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dates[section].monthDateFormate()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = .white
            header.textLabel?.textColor = .black
        }
    }
}
