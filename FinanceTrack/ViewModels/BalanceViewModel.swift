import Foundation

class BalanceViewModel {
    private var repository: BalanceRepository
    
    init() {
        repository = RealmBalanceRepository()
    }
        
    func get() -> Double {
        return repository.get()
    }
}

