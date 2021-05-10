import Foundation

protocol BalanceRepository {
    func get() -> Double
    func add(amount: Double)
    func substract(amount: Double)
}
