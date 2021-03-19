import UIKit
import PanModal
import DropDown

class AllExpensesViewController: UIViewController {
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
        cell.amountLabel.text = String(currExpense.amount)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Array(expenses)[section].value.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        expenses.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Array(expenses)[section].key
    }
}

extension AllExpensesViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(600)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
    
}
