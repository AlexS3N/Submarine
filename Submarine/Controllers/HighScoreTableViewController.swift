
import UIKit

class HighScoreTableViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    //MARK: - var/let
    var arrayResults = UserDefaultsManager.shared.loadResult()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.layer.cornerRadius = 10
        if self.arrayResults.isEmpty {
            self.tableView.isHidden = true
            self.infoLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.infoLabel.isHidden = true
        }
        self.highScoreLabel.text = "High Score Table".localized
        self.infoLabel.text = "Info Label".localized
    }
    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

    //MARK: - Extensions
extension HighScoreTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as? ResultsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: arrayResults.reversed()[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.5
    }
}
