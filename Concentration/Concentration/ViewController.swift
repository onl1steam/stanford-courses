//
//  ViewController.swift
//  Concentration
//
//  Created by Рыжков Артем on 16/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    private var emojiChoices = [String]()
    
    private var emojiThemes: [String: [String]] = [
        "Fruits" : ["🍏", "🥥", "🍐", "🍒", "🍍", "🍉", "🥝", "🍇", "🍊", "🍑"],
        "Faces" : ["😀", "😂", "😎", "😱", "🤠", "😵", "😩", "😬", "🤯", "😍"],
        "Activity" : ["🏀", "⚽️", "⚾️", "🏈", "🎮", "🏂", "⛸", "🎳", "🏓", "🤺"],
        "Animals" : ["🦊", "🐱", "🐶", "🐔", "🐥", "🐸", "🐨", "🐵", "🦉", "🦔"],
        "Flags" : ["🇷🇺", "🇯🇵", "🇺🇾", "🇺🇸", "🇪🇸", "🇬🇧", "🇯🇲", "🇵🇹", "🇮🇹", "🏴‍☠️"],
        "Clothes" : ["👚", "👖", "👔", "👠", "🧢", "🧤", "🥋", "👗", "🧣", "👘"],
        "Halloween" : ["🎃", "👽", "😈", "🙀", "😱", "🕷", "🕸", "🦇", "👻", "🎭"],
        "Christmas" : ["⛄️", "❄️", "🎄", "🎿", "🎉", "🥂", "🎁", "🎊", "🎅", "🔔"],
        "Transport" : ["🚕", "🚗", "🚎", "🚜", "🛵", "🚔", "🚖", "🚒", "🚑", "🚲"]
    ]
    
    private var indexTheme = 0 {
        didSet {
            emojiChoices = emojiThemes[keys [indexTheme]] ?? []
            emoji = [Int: String]()
        }
    }
    
    private var keys: [String] {
        return Array(emojiThemes.keys)
    }
    
    private var emoji = [Int: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        indexTheme = Int.random(in: 0..<keys.count)
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: Int.random(in: 0..<emojiChoices.count))
        }
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func newGame(_ sender: Any) {
        game.resetGame()
        indexTheme = Int.random(in: 0..<keys.count)
        updateViewFromModel()
    }
}

