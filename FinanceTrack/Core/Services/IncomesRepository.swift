import Foundation

protocol IncomesRepository {
    func listAll() -> [Income]
    func add(amount: Int, date: Date)
}
