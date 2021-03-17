import UIKit
import PanModal
import DropDown

class AllExpensesViewController: UIViewController {
    private var expensesViewModel = ExpensesViewModel()
    private var categoriesViewModel = CategoriesViewModel()
    private var expenses: [Expense] = []
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseTableViewCell
        cell.expenseLabel.text = expenses[indexPath.row].info
        cell.amountLabel.text = String(expenses[indexPath.row].amount)
        return cell
    }
}

extension AllExpensesViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
    
}
