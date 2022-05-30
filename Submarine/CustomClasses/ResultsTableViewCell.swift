
import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configure(with result: GameResult) {
        self.playerNameLabel.text = result.playerName
        self.scoreLabel.text = result.result
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        let string = formatter.string(from: result.timeGame)
        self.dateLabel.text = string
    }
    
}
