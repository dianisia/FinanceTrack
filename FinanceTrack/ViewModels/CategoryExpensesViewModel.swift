import Foundation

class CategoryExpensesViewModel: ExpensesViewModelProtocol {
    var expensesRepository: ExpensesRepository
    private var category: Category
    
    init(category: Category) {
        expensesRepository = DIContainer.expensesRepository
        self.category = category
    }
    
    var expenses: ExpensesForDate {
        get {
            listGroupedByDate(for: category.categoryId, period: .allTime)
        }
    }
    
    func getExpensesForPeriod(period: Period) -> ExpensesForDate {
        listGroupedByDate(for: category.categoryId, period: period)
    }
    
    func getTotal(period: Period) -> [TotalExpenseForDate]  {
        return getTotalForDate(period: period, categoryId: self.category.categoryId)
    }
    
    func prepareGraphData(period: Period) -> GraphData {
        let groupedData = getTotal(period: period)
        let data: [Double] = groupedData.map { $0.amount }
        return GraphData(labels: groupedData.map { $0.date.monthDateFormate() } , data: data)
    }
    
    func getCategoryName() -> String {
        category.name
    }
}
