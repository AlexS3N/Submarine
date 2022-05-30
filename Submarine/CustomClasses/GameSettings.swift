
import UIKit

class GameSettings: Codable {
    
    var playerName: String
    var appearanceSubmarine: String
    var appearanceEnemy: String
    
    init(playerName: String, appearanceSubmarine: String, appearanceEnemy: String) {
        self.playerName = playerName
        self.appearanceSubmarine = appearanceSubmarine
        self.appearanceEnemy = appearanceEnemy
    }
    
    private enum CodingKeys: String, CodingKey {
        case playerName
        case appearanceSubmarine
        case appearanceEnemy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerName, forKey: .playerName)
        try container.encode(appearanceSubmarine, forKey: .appearanceSubmarine)
        try container.encode(appearanceEnemy, forKey: .appearanceEnemy)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.playerName = try container.decode(String.self, forKey: .playerName)
        self.appearanceSubmarine = try container.decode(String.self, forKey: .appearanceSubmarine)
        self.appearanceEnemy = try container.decode(String.self, forKey: .appearanceEnemy)
    }
}
