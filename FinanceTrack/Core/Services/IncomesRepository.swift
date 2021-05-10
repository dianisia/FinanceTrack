import Foundation

protocol IncomesRepository {
    func listAll() -> [Income]
    func listAll(period: Period) -> [Income]
    
    func add(amount: Double, date: Date)
    func getTotal(for period: Period) -> Double
}
