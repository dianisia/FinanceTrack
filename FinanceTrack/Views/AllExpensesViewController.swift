import UIKit
import PanModal

class AllExpensesViewController: UIViewController {
    private var expensesViewModel = ExpensesViewModel()
    private var expenses: [Expense] = []
    
    var closePanel: (() -> ())?
    
    @IBAction func onCloseTap(_ sender: Any) {
        closePanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenses = expensesViewModel.expenses
    }
}

extension AllExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseTableViewCell
        cell.expenseLabel.text = "Test"
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
