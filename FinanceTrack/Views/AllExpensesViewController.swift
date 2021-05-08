import UIKit
import PanModal
import DropDown

class AllExpensesViewController: UIViewController {
    
    struct CurrConstants {
        static let viewHeight: CGFloat = 700
        static let viewMaxHeightWithTopInset: CGFloat = 40
    }
    
    private var expensesViewModel = ExpensesViewModel()
    private var categoriesViewModel = CategoriesViewModel()
    private var expenses: ExpensesForDate = [:]
    private var dates: [Date] = []
    private var categories: [Category] = []
    @IBOutlet weak var expensesTableView: UITableView!
    
    var closePanel: (() -> ())?
    
    @IBAction func onCloseTap(_ sender: Any) {
        closePanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        expenses = expensesViewModel.expenses
        dates = Array(expenses.keys).sorted(by: <)
        categories = categoriesViewModel.categories
        expensesTableView.reloadData()
    }
}

extension AllExpensesViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses[dates[section]]?.count ?? 0
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

extension AllExpensesViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(CurrConstants.viewHeight)
    }
    
    var longFormHeight: PanModalHeight {
        .maxHeightWithTopInset(CurrConstants.viewMaxHeightWithTopInset)
    }
    
}
