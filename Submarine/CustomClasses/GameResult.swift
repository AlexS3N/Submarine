
import UIKit

class GameResult: Codable {
    
    var playerName: String
    var result: String
    var timeGame: Date
    
    init(playerName: String, result: String, timeGame: Date) {
        self.playerName = playerName
        self.result = result
        self.timeGame = timeGame
    }
    
    private enum CodingKeys: String, CodingKey {
        case playerName
        case result
        case timeGame
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerName, forKey: .playerName)
        try container.encode(result, forKey: .result)
        try container.encode(timeGame, forKey: .timeGame)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.playerName = try container.decode(String.self, forKey: .playerName)
        self.result = try container.decode(String.self, forKey: .result)
        self.timeGame = try container.decode(Date.self, forKey: .timeGame)
    }
}
