import Foundation

class BalanceViewModel {
    private var repository: BalanceRepository
    
    init() {
        repository = DIContainer.balanceRepository
    }
        
    func get() -> Double {
        return repository.get()
    }
}

