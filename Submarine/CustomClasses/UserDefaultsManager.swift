
import UIKit

class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private init() {}
        
    func saveResult(_ result: GameResult) {
        var results = self.loadResult()
        results.append(result)
        UserDefaults.standard.set(encodable: results, forKey: "gameResults")
    }
    
    func loadResult() -> [GameResult] {
        guard let results = UserDefaults.standard.value([GameResult].self, forKey: "gameResults") else {
            return []
        }
        return results
    }
}
