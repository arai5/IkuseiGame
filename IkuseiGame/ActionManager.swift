//
//  ActionManager.swift
//  IkuseiGame
//
//  Created by student on 2025/05/08.
//

import Foundation

/// ユーザーアクションごとのステータス更新を担当するクラス
final class ActionManager {
    private var character: CharacterModel
    
    init(character: CharacterModel) {
        self.character = character
    }
    
    /// 餌を与える
    func feed(amount: Int) -> CharacterModel {
        character.feed(amount: amount)
        return character
    }
    
    /// トイレ掃除
    func cleanToilet(amount: Int) -> CharacterModel {
        character.cleanToilet(amount: amount)
        return character
    }
    
    /// 遊ぶ
    func play(amount: Int) -> CharacterModel {
        character.play(amount: amount)
        return character
    }
}
