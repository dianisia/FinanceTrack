import Foundation

protocol BalanceProtocol {
    var value: Double {get set}
}

struct Balance: BalanceProtocol {
    var value: Double
}
