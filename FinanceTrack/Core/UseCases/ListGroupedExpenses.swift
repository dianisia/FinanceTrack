import Foundation

protocol ListGroupedExpenses {
    func callAsFunction() -> GroupedExpenses
}

class ListGroupedExpensesImpl: ListGroupedExpenses {
    private let repository: ExpensesRepository

    init(repository: ExpensesRepository) {
        self.repository = repository
    }

    func callAsFunction() -> GroupedExpenses {
        let expenses = repository.listAll()
        var result: GroupedExpenses = [:]
        for expense in expenses {
            let currDate = Helper.formateDate(date: expense.date)
            if result.keys.contains(currDate) {
                result[currDate]?.append(expense)
            } else {
                result[currDate] = [expense]
            }
        }
        return result
    }
}
