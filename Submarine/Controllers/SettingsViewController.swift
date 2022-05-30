
import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var submarineSelectView: UIView!
    @IBOutlet weak var firstEnemyView: UIView!
    @IBOutlet weak var secondEnemyView: UIView!
    @IBOutlet weak var thirdEnemyView: UIView!
    @IBOutlet weak var chooseSubmarineLabel: UILabel!
    @IBOutlet weak var chooseEnemyLabel: UILabel!
    
    //MARK: - var/let
    var indicator: Int = 0
    var indicatorEnemy: Int = 0
    let gameSettings = GameSettings(playerName: "", appearanceSubmarine: "submarine", appearanceEnemy: "torpedo")
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSettings()
        self.localizeInterface()
    }
    
    //MARK: - IBActions
    @IBAction func firstSubmarineButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.firstView)
        self.unSelect(anyView: self.secondView)
        self.unSelect(anyView: self.thirdView)
        self.indicator = 1
    }
    @IBAction func secondSubmarineButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.secondView)
        self.unSelect(anyView: self.firstView)
        self.unSelect(anyView: self.thirdView)
        self.indicator = 2
    }
    @IBAction func thirdSubmarineButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.thirdView)
        self.unSelect(anyView: self.firstView)
        self.unSelect(anyView: self.secondView)
        self.indicator = 3
    }
    @IBAction func firstEnemyButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.firstEnemyView)
        self.unSelect(anyView: self.secondEnemyView)
        self.unSelect(anyView: self.thirdEnemyView)
        self.indicatorEnemy = 1
    }
    @IBAction func secondEnemyButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.secondEnemyView)
        self.unSelect(anyView: self.firstEnemyView)
        self.unSelect(anyView: self.thirdEnemyView)
        self.indicatorEnemy = 2
    }
    @IBAction func thirdEnemyButtonPressed(_ sender: UIButton) {
        self.select(anyView: self.thirdEnemyView)
        self.unSelect(anyView: self.firstEnemyView)
        self.unSelect(anyView: self.secondEnemyView)
        self.indicatorEnemy = 3
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.checkAndSetSettingsBack()
        UserDefaults.standard.set(encodable: gameSettings, forKey: "firstPlayerSettings")
    }
    //MARK: - Flow functions
    private func select(anyView: UIView) {
        anyView.layer.borderWidth = 2
        anyView.layer.cornerRadius = 15
        anyView.layer.borderColor = UIColor.systemYellow.cgColor
    }
    private func unSelect(anyView: UIView) {
        anyView.layer.borderWidth = 0
    }
    private func loadSettings() {
        let settings = UserDefaults.standard.value(GameSettings.self, forKey: "firstPlayerSettings")
        switch settings?.appearanceSubmarine {
        case "submarine":
            self.select(anyView: self.firstView)
            self.indicator = 1
        case "CyberSubmarine":
            self.select(anyView: self.secondView)
            self.indicator = 2
        case "cartoonSubmarine":
            self.select(anyView: self.thirdView)
            self.indicator = 3
        default:
            self.select(anyView: self.firstView)
            self.indicator = 1
        }
        switch settings?.appearanceEnemy {
        case "torpedo":
            self.select(anyView: self.firstEnemyView)
            self.indicatorEnemy = 1
        case "shark":
            self.select(anyView: self.secondEnemyView)
            self.indicatorEnemy = 2
        case "SeaUrchin":
            self.select(anyView: self.thirdEnemyView)
            self.indicatorEnemy = 3
        default:
            self.select(anyView: self.firstEnemyView)
            self.indicatorEnemy = 1
        }
    }
    
    private func checkAndSetSettingsBack() {
        switch indicator {
        case 1:
            self.gameSettings.appearanceSubmarine = "submarine"
        case 2:
            self.gameSettings.appearanceSubmarine = "CyberSubmarine"
        case 3:
            self.gameSettings.appearanceSubmarine = "cartoonSubmarine"
        default:
            self.gameSettings.appearanceSubmarine = "submarine"
        }
        switch indicatorEnemy {
        case 1:
            self.gameSettings.appearanceEnemy = "torpedo"
        case 2:
            self.gameSettings.appearanceEnemy = "shark"
        case 3:
            self.gameSettings.appearanceEnemy = "SeaUrchin"
        default:
            self.gameSettings.appearanceEnemy = "torpedo"
        }
    }
    
    private func localizeInterface() {
        self.chooseSubmarineLabel.text = "Choose Submarine".localized
        self.chooseEnemyLabel.text = "Choose Enemy".localized
    }
}
