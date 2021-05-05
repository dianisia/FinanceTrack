import UIKit
import PanModal
import DropDown

class AllExpensesViewController: UIViewController {

    struct CurrConstants {
        static let viewHeight: CGFloat = 600
        static let viewMaxHeightWithTopInset: CGFloat = 40
    }

    private var expensesViewModel = ExpensesViewModel()
    private var categoriesViewModel = CategoriesViewModel()
    private var expenses: GroupedExpenses = [:]
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
        categories = categoriesViewModel.categories
        expensesTableView.reloadData()
    }
}

extension AllExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseTableViewCell
        let currExpense: Expense = Array(expenses)[indexPath.section].value[indexPath.row]
        cell.expenseLabel.text = currExpense.info
        cell.amountLabel.text = Helper.formateExpense(amount: currExpense.amount)
        cell.iconBackUIView.backgroundColor = Helper
                .UIColorFromHex(rgbValue: UInt32(Constants.categoryColors[currExpense.category.colorIndex]))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Array(expenses)[section].value.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        expenses.keys.count
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
