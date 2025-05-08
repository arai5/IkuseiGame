import Foundation

/// キャラクターの成長段階
enum GrowthStage {
    case baby   // 幼少期
    case child  // 成長期
    case adult  // 成熟期
    case dead   // 死亡
}

/// キャラクターのステータスモデル
struct CharacterModel {
    // MARK: - 定数
    private let maxHealth = 100
    private let maxEnvironment = 100
    private let maxAffection = 100
    private let healthDecayRate: Double = 1.0      // 1秒あたりの体力減少量
    private let environmentDecayRate: Double = 0.5 // 1秒あたりの環境減少量
    private let childAffectionThreshold = 20      // 成長期への好感度閾値
    private let adultAffectionThreshold = 50      // 成熟期への好感度閾値
    private let minHealthForGrowth = 20           // 成長に必要な最低体力
    private let maxLifeTime: TimeInterval = 60 * 60 * 24 * 7  // 7日

    // MARK: - プロパティ
    /// 生命力（0以下で死亡）
    var health: Int = 100
    
    /// 生活環境（0~100）
    var environment: Int = 100
    
    /// ユーザーとの好感度（0~100）
    var affection: Int = 0
    
    /// 現在の成長段階
    var stage: GrowthStage = .baby
    
    /// 誕生時刻
    private let birthDate: Date = Date()
    
    /// 最終ステータス更新時刻
    private var lastUpdate: Date = Date()
    
    // MARK: - 更新ロジック
    /// 経過時間によるステータス更新
    mutating func updateStatus() {
        let now = Date()
        let delta = now.timeIntervalSince(lastUpdate)
        // 時間経過による減少
        let healthLoss = Int(delta * healthDecayRate)
        let envLoss = Int(delta * environmentDecayRate)
        health = max(health - healthLoss, 0)
        environment = max(environment - envLoss, 0)
        lastUpdate = now
        // 状態チェック
        checkDeath(by: delta)
        checkGrowth()
    }
    
    // MARK: - ユーザーアクション
    /// 餌を与える
    mutating func feed(amount: Int) {
        health = min(health + amount, maxHealth)
        if health > maxHealth { health = maxHealth }
        // 与えすぎ防止の例: 健康が一定以上だと逆効果
        if health > maxHealth / 2 {
            health = max(health - amount / 2, 0)
        }
        updateStatus()
    }
    
    /// トイレ掃除
    mutating func cleanToilet(amount: Int) {
        environment = min(environment + amount, maxEnvironment)
        updateStatus()
    }
    
    /// 遊ぶ
    mutating func play(amount: Int) {
        affection = min(affection + amount, maxAffection)
        updateStatus()
    }
    
    // MARK: - プライベートチェック
    /// 死亡判定
    private mutating func checkDeath(by elapsed: TimeInterval) {
        if health <= 0 || Date().timeIntervalSince(birthDate) >= maxLifeTime {
            stage = .dead
        }
    }
    
    /// 成長判定
    private mutating func checkGrowth() {
        guard stage != .dead else { return }
        switch stage {
        case .baby:
            if affection >= childAffectionThreshold && health >= minHealthForGrowth {
                stage = .child
            }
        case .child:
            if affection >= adultAffectionThreshold && health >= minHealthForGrowth {
                stage = .adult
            }
        default:
            break
        }
    }
}
