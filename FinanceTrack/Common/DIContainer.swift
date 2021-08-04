import Foundation

final class DIContainer {
    static var categoriesRepository: CategoriesRepository = RealmCategoriesRepository()
    static var expensesRepository: ExpensesRepository = RealmExpensesRepository()
    static var balanceRepository: BalanceRepository = RealmBalanceRepository()
    static var incomesRepository: IncomesRepository = RealmIncomesRepository()
}
