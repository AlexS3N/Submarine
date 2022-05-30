
import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var playButtonPressed: UIButton!
    @IBOutlet weak var settingsButtonPressed: UIButton!
    @IBOutlet weak var highScoreTableButtonPressed: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCrashButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscape)
        self.setupUI()
        self.localizeInterface()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.landscape)
    }
    
    //MARK: - IBActions
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
         let numbers = [0]
         let _ = numbers[1]
     }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as? PlayViewController else {
            print("Controllers does not exist.")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            print("Controllers does not exist.")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func highScoreTableButtonPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreTableViewController") as? HighScoreTableViewController else {
            print("Controllers does not exist.")
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Flow functions
    private func localizeInterface() {
        self.playButtonPressed.setTitle("Play".localized, for: .normal)
        self.settingsButtonPressed.setTitle("Settings".localized, for: .normal)
        self.highScoreTableButtonPressed.setTitle("High Score Table".localized, for: .normal)
    }
    
    private func createCrashButton() {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    private func setupUI() {
        self.playButtonPressed.roundCorners()
        self.settingsButtonPressed.roundCorners()
        self.highScoreTableButtonPressed.roundCorners()
        self.highScoreTableButtonPressed.dropShadow()
        self.settingsButtonPressed.dropShadow()
        self.playButtonPressed.dropShadow()
        self.highScoreTableButtonPressed.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}
