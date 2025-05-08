import UIKit

class ViewController: UIViewController {
    // MARK: - UI Outlets
    @IBOutlet weak var statusBaseView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var bottomBaseView: UIView!

    @IBOutlet weak var hpProgressView: UIProgressView!
    @IBOutlet weak var environmentProgressView: UIProgressView!
    @IBOutlet weak var affectionProgressView: UIProgressView!

    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cleaningButton: UIButton!

    // MARK: - Model
    private var character = CharacterModel()
    private var statusTimer: Timer?
    private var actionManager: ActionManager!

    // MARK: - Constants
    private let updateInterval: TimeInterval = 5.0
    private let feedAmount = 20
    private let cleanAmount = 15
    private let playAmount = 10

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // ActionManager の初期化
        actionManager = ActionManager(character: character)
        setupUI()
        startStatusTimer()
    }

    deinit {
        statusTimer?.invalidate()
    }

    // MARK: - Timer
    private func startStatusTimer() {
        statusTimer = Timer.scheduledTimer(timeInterval: updateInterval,
                                           target: self,
                                           selector: #selector(timerFired),
                                           userInfo: nil,
                                           repeats: true)
    }

    @objc private func timerFired() {
        character.updateStatus()
        refreshUI()
    }

    // MARK: - Actions
    @IBAction func eatButtonTapped(_ sender: UIButton) {
        character = actionManager.feed(amount: feedAmount)
        refreshUI()
    }

    @IBAction func cleaningButtonTapped(_ sender: UIButton) {
        character = actionManager.cleanToilet(amount: cleanAmount)
        refreshUI()
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        character = actionManager.play(amount: playAmount)
        refreshUI()
    }

    // MARK: - UI Setup & Refresh
    private func setupUI() {
        // ベースビューのスタイル
        statusBaseView.layer.cornerRadius = 8
        statusBaseView.layer.shadowOpacity = 0.2
        bottomBaseView.layer.cornerRadius = 8
        bottomBaseView.layer.shadowOpacity = 0.2

        // プログレスバー初期化
        hpProgressView.progress = 1.0
        environmentProgressView.progress = 1.0
        affectionProgressView.progress = 0.0

        refreshUI()
    }

    private func refreshUI() {
        // プログレスバー更新
        hpProgressView.progress = Float(character.health) / 100
        environmentProgressView.progress = Float(character.environment) / 100
        affectionProgressView.progress = Float(character.affection) / 100

        // キャラクター画像切替
        switch character.stage {
        case .baby:
            characterImageView.image = UIImage(named: "character_baby")
        case .child:
            characterImageView.image = UIImage(named: "character_child")
        case .adult:
            characterImageView.image = UIImage(named: "character_adult")
        case .dead:
            characterImageView.image = UIImage(named: "character_dead")
            statusTimer?.invalidate()
            showGameOverAlert()
        }
    }

    // MARK: - Helpers
    private func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "キャラクターが亡くなりました。", preferredStyle: .alert)
        let restart = UIAlertAction(title: "再誕生", style: .default) { _ in
            self.character = CharacterModel()
            self.actionManager = ActionManager(character: self.character)
            self.setupUI()
            self.startStatusTimer()
        }
        alert.addAction(restart)
        present(alert, animated: true)
    }
}


