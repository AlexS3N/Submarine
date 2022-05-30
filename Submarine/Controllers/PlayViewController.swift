
import UIKit
import CoreMotion

class PlayViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var endGameMenu: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var endGameMenuLabel: UILabel!
    @IBOutlet weak var backMenuButton: UIButton!
    @IBOutlet weak var restartGameButton: UIButton!
    @IBOutlet weak var settingsMenuButton: UIButton!
    @IBOutlet weak var saveResultButton: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var oxygenScaleView: UIView!
    @IBOutlet weak var oxygenLevelLabel: UILabel!
    @IBOutlet weak var skyView: UIView!
    @IBOutlet weak var seaView: UIView!
    @IBOutlet weak var submarine: UIImageView!
    
    //MARK: - var/let
    var manager = CMMotionManager()
    var scoreLabel: UILabel?
    var torpeda: UIImageView?
    var ship: UIImageView?
    var oxygen: UIImageView?
    var torpedaArray:[UIImageView] = []
    var shipArray:[UIImageView] = []
    var oxygenArray:[UIImageView] = []
    var torpedaTimer = Timer()
    var shipTimer = Timer()
    var oxygenTimer = Timer()
    var checkLocationOxygenTimer = Timer()
    var startFrameSubmarine: CGRect!
    var isSubmarineDestroyed: Bool = false
    var amountOxygen = 15 {
        didSet {
            self.oxygenLevelLabel.text = "\(self.amountOxygen)"}
    }
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score".localized + ": \(self.score)"
        }
    }
    let settings = UserDefaults.standard.value(GameSettings.self, forKey: "firstPlayerSettings")
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapRecognizer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.startFrameSubmarine = self.submarine.frame
        self.beginGame()
        self.submarine.image = UIImage(named: settings?.appearanceSubmarine ?? "submarine")
        self.torpeda?.image = UIImage(named: settings?.appearanceEnemy ?? "torpedo")
        self.localizeInterface()
    }
    private func setupUI() {
        self.addScoreLabel()
        self.endGameMenu.layer.cornerRadius = 30
        self.saveResultButton.roundCorners()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addAccelerometer()
        self.addGyro()
    }
    //MARK: - IBActions
    @IBAction func backMenuButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func restartGameButtonPressed(_ sender: UIButton) {
        self.startGame()
    }
    @IBAction func settingsMenuButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func saveResultButtonPressed(_ sender: UIButton) {
        let gameResult = GameResult(playerName: "", result: "", timeGame: Date())
        if let playerName = self.textFieldName.text {
            if playerName == "" {
                gameResult.playerName = "Player".localized} else {
                    gameResult.playerName = playerName
                }
        } else {
            gameResult.playerName = "Player".localized
        }
        gameResult.result = String(self.score)
        UserDefaultsManager.shared.saveResult(gameResult)
        self.showSaveAlert()
    }
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    //MARK: - Up/Down Submarine
    private func moveUp() {
        if self.submarine.frame.minY > self.skyView.frame.maxY + 10
        {
            UIView.animate(withDuration: 0.3) {
                self.submarine.frame.origin.y -= 10}
        } else { self.submarine.frame.origin.y = self.skyView.frame.maxY}
    }
    private func moveDown() {
        if self.submarine.frame.maxY < self.view.frame.maxY {
            if self.submarine.frame.maxY + 10 > self.view.frame.maxY {
                self.submarine.frame.origin.y = self.view.frame.maxY - self.submarine.frame.height
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.submarine.frame.origin.y += 10}
            }
        } else { self.endGame()}
    }
    private func moveUpForce() {
        UIView.animate(withDuration: 0.3) {
            self.submarine.frame.origin.y = self.skyView.frame.maxY
        }
    }
    //MARK: - Torpeda
    private func addTorpeda() {
        let frame: CGRect = CGRect(x: self.view.frame.maxX, y: .random(in: self.skyView.frame.maxY + 20...self.seaView.frame.maxY - 15), width: 100, height: 10)
        let torpeda: UIImageView = UIImageView(frame: frame)
        torpeda.image = UIImage(named: settings?.appearanceEnemy ?? "torpedo")
        torpeda.contentMode = .scaleAspectFill
        self.torpeda = torpeda
        self.torpedaArray.append(torpeda)
        self.view.addSubview(torpeda)
    }
    private func checkTorpeda() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            for i in 0..<self.torpedaArray.count {
                if let torpedaFrame = self.torpedaArray[i].layer.presentation()?.frame,
                   let submarineFrame = self.submarine.layer.presentation()?.frame {
                    if torpedaFrame.intersects(submarineFrame) {
                        self.endGame()
                        timer.invalidate()
                    }
                }
            }
        }
    }
    private func moveTorpeda() {
        guard let torpeda = self.torpeda else {
            print("Torpeda does not exist.")
            return
        }
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear) {
            torpeda.frame.origin.x = self.view.frame.minX - torpeda.frame.width
        } completion: { _ in
            torpeda.removeFromSuperview()
            if !self.torpedaArray.isEmpty {
                self.torpedaArray.removeFirst()}
        }
    }
    private func launchTorpedaTimer() {//launchTimerTorpeda
        self.torpedaTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.addTorpeda()
            self.moveTorpeda()
        }
        torpedaTimer.fire()
    }
    //MARK: - Ship
    private func addShip() {
        let frame: CGRect = CGRect(x: self.view.frame.maxX, y: self.skyView.frame.maxY - 80, width: 140, height: 100)
        let ship: UIImageView = UIImageView(frame: frame)
        ship.image = UIImage(named: "ship")
        ship.contentMode = .scaleAspectFill
        self.ship = ship
        self.shipArray.append(ship)
        self.view.addSubview(ship)
    }
    private func moveShip() {
        guard let ship = self.ship else {
            print("Ship does not exist.")
            return
        }
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear) {
            ship.frame.origin.x = self.view.frame.minX - ship.frame.width
        } completion: { _ in
            ship.removeFromSuperview()
            self.shipArray.removeFirst()
        }
    }
    private func checkShip() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            for i in 0..<self.shipArray.count {
                if let shipFrame = self.shipArray[i].layer.presentation()?.frame,
                   let submarineFrame = self.submarine.layer.presentation()?.frame {
                    if shipFrame.intersects(submarineFrame) {
                        self.endGame()
                        timer.invalidate()
                    }
                }
            }
        }
    }
    private func launchShipTimer() {
        self.shipTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.addShip()
            self.moveShip()
        }
        shipTimer.fire()
    }
    //MARK: - Oxygen
    private func addOxygen() {
        let frame: CGRect = CGRect(x: self.view.frame.maxX, y: .random(in: self.skyView.frame.maxY...self.seaView.frame.maxY - 75), width: 60, height: 60)
        let oxygen = UIImageView(frame: frame)
        oxygen.image = UIImage(named: "oxygen")
        oxygen.contentMode = .scaleAspectFill
        self.oxygen = oxygen
        self.oxygenArray.append(oxygen)
        self.view.addSubview(oxygen)
    }
    private func moveOxygen() {
        guard let oxygen = self.oxygen else {
            return
        }
        UIView.animate(withDuration: 4, delay: 0, options: .curveLinear) {
            oxygen.frame.origin.x = self.view.frame.minX - oxygen.frame.width
        } completion: { _ in
            oxygen.removeFromSuperview()
            self.oxygenArray.removeFirst()
        }
    }
    private func checkLocationOxygen() {
        self.checkLocationOxygenTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { _ in
            for oxygen in self.oxygenArray {
                if let oxygenFrame = oxygen.layer.presentation()?.frame,
                   let submarineFrame = self.submarine.layer.presentation()?.frame {
                    if oxygenFrame.intersects(submarineFrame) {
                        oxygen.removeFromSuperview()
                        if self.amountOxygen >= 20 {
                            self.amountOxygen = 30
                        } else {self.amountOxygen += 10}
                    }
                }
            }
        }
    }
    private func launchOxygenTimer() {
        self.oxygenTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.addOxygen()
            self.moveOxygen()
        }
    }
    //MARK: - Flow functions
    private func timerAmountOxygen() {
        self.oxygenLevelLabel.text = "\(self.amountOxygen)"
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.amountOxygen == 1 && self.isSubmarineDestroyed == false {
                timer.invalidate()
                self.endGame()
                self.amountOxygen = 0
            } else if self.isSubmarineDestroyed == true {
                timer.invalidate()
            } else { self.amountOxygen -= 1 }
        }
    }
    private func showSaveAlert() {
        let alert = UIAlertController(title: .none, message: "Result has been saved.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    private func changeColorOxygenLevel() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            if self.isSubmarineDestroyed == true || self.amountOxygen == 0 {
                timer.invalidate()
            }
            switch self.amountOxygen {
            case 15...:
                self.oxygenScaleView.backgroundColor = .green
            case 12...15:
                UIView.animate(withDuration: 3) {
                    self.oxygenScaleView.backgroundColor = .yellow
                }
            case 0...12:
                UIView.animate(withDuration: 12) {
                    self.oxygenScaleView.backgroundColor = .red
                }
            default:
                self.oxygenScaleView.backgroundColor = .green
            }
        }
    }
    private func addTapRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func localizeInterface() {
        self.gameOverLabel.text = "GAME OVER".localized
        self.saveResultButton.setTitle("Save Result".localized, for: .normal)
        self.textFieldName.attributedPlaceholder = NSAttributedString(string: "Enter your PlayerName".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
    }
    private func addAccelerometer() {
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.1
            manager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                if let acceleration = data?.acceleration {
                    if acceleration.z >= -0.9 && acceleration.z <= -0.8 {
                        self?.moveUp()
                    }
                    if acceleration.z <= -0.2 && acceleration.z >= -0.7 {
                        self?.moveDown()
                    }
                    debugPrint("x: \(acceleration.x)")
                    debugPrint("y: \(acceleration.y)")
                    debugPrint("z: \(acceleration.z)")
                }
            }
        }
    }
    private func addGyro() {
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates(to: .main) { [weak self] data, error in
                if let gyro = data?.rotationRate {
                    if gyro.x > 7 || gyro.x < -7 {
                        self?.moveUpForce()
                    }
                    if gyro.y > 7 || gyro.y < -7 {
                        self?.moveUpForce()
                    }
                    if gyro.y > 7 || gyro.y < -7 {
                        self?.moveUpForce()
                    }
                }
            }
        }
    }
    //MARK: - Explosion
    private func endGame() {
        self.invalidateTimer()
        self.endGameMenu.isHidden = false
        self.submarine.image = UIImage(named: "explosion")
        self.isSubmarineDestroyed = true
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            self.submarine.isHidden = true
        }
        for torpeda in torpedaArray{
            torpeda.removeFromSuperview()
        }
        for ship in shipArray {
            ship.removeFromSuperview()
        }
        for oxygen in oxygenArray {
            oxygen.removeFromSuperview()
        }
        print("Score is \(score).")
        self.endGameMenuLabel.text = "Your score".localized + ": \(self.score)"
    }
    private func startGame() {
        self.torpedaArray.removeAll()
        self.shipArray.removeAll()
        self.beginGame()
        self.submarine.frame = self.startFrameSubmarine
        self.submarine.image = UIImage(named: settings?.appearanceSubmarine ?? "submarine")
        self.submarine.isHidden = false
        self.isSubmarineDestroyed = false
        self.amountOxygen = 15
        self.score = 0
    }
    
    private func beginGame() {
        self.endGameMenu.isHidden = true
        self.oxygenScaleView.backgroundColor = .green
        self.launchTorpedaTimer()
        self.checkTorpeda()
        self.launchShipTimer()
        self.checkShip()
        self.timerScore()
        self.launchOxygenTimer()
        self.checkLocationOxygen()
        self.timerAmountOxygen()
        self.changeColorOxygenLevel()
    }

    //MARK: - Score
    private func timerScore() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isSubmarineDestroyed == true {
                timer.invalidate()
            } else { self.score += 1}
        }
    }
    private func addScoreLabel() {
        let frame = CGRect(x: self.view.frame.width/2 - 25, y: 10, width: 100, height: 20)
        let scoreLabel = UILabel(frame: frame)
        scoreLabel.font = UIFont(name: "Troika", size: 18)
        scoreLabel.text = "Score".localized + ": \(self.score)"
        scoreLabel.backgroundColor = .clear
        self.scoreLabel = scoreLabel
        self.view.addSubview(scoreLabel)
    }
    private func invalidateTimer() {
        self.torpedaTimer.invalidate()
        self.shipTimer.invalidate()
        self.oxygenTimer.invalidate()
        self.checkLocationOxygenTimer.invalidate()
    }
}

    //MARK: - Extensions
extension PlayViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


