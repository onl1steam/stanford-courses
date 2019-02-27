//
//  ViewController.swift
//  Concentration
//
//  Created by Рыжков Артем on 16/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var backgroundColor = UIColor.black
    private var cardBackColor = UIColor.orange
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    struct Theme {
        var name: String
        var emojis: String
        var viewColor: UIColor
        var cardColor: UIColor
    }
    
    private var emojiChoices = String()
    
    private var emojiThemes: [Theme] = [
        Theme(name: "Fruits",
              emojis: "🍏🥥🍐🍒🍍🍉🥝🍇🍊🍑",
              viewColor: #colorLiteral(red: 0, green: 0.645991385, blue: 1, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        Theme(name: "Faces",
              emojis: "😀😂😎😱🤠😵😩😬🤯😍",
              viewColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)),
        Theme(name: "Activity",
              emojis: "🏀⚽️⚾️🏈🎮🏂⛸🎳🏓🤺",
              viewColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        Theme(name: "Animals",
              emojis: "🦊🐱🐶🐔🐥🐸🐨🐵🦉🦔",
              viewColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
        Theme(name: "Flags",
              emojis: "🇷🇺🇯🇵🇺🇾🇺🇸🇪🇸🇬🇧🇯🇲🇵🇹🇮🇹🏴‍☠️",
              viewColor: #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1) ,
              cardColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)),
        Theme(name: "Clothes",
              emojis: "👚👖👔👠🧢🧤🥋👗🧣👘",
              viewColor: #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)),
        Theme(name: "Halloween",
              emojis: "🎃👽😈🙀😱🕷🕸🦇👻🎭",
              viewColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,
              cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        Theme(name: "Christmas",
              emojis: "⛄️❄️🎄🎿🎉🥂🎁🎊🎅🔔",
              viewColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) ,
              cardColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
        Theme(name: "Transport",
              emojis: "🚕🚗🚎🚜🛵🚔🚖🚒🚑🚲",
              viewColor: #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1) ,
              cardColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))
    ]
    
    private var indexTheme = 0 {
        didSet {
            emoji = [Card: String]()
            titleLabel.text = emojiThemes[indexTheme].name
            
            emojiChoices = emojiThemes[indexTheme].emojis
            cardBackColor = emojiThemes[indexTheme].cardColor
            backgroundColor = emojiThemes[indexTheme].viewColor
            
            updateAppearance()
        }
    }
    
    private var emoji = [Card: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = Int.random(in: 0..<emojiThemes.count)
        updateViewFromModel()
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackColor
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: Int.random(in: 0..<emojiChoices.count))
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction func newGame(_ sender: Any) {
        game.resetGame()
        indexTheme = Int.random(in: 0..<emojiThemes.count)
        updateViewFromModel()
    }
    
    private func updateAppearance() {
        view.backgroundColor = backgroundColor
        titleLabel.textColor = cardBackColor
        flipCountLabel.textColor = cardBackColor
        scoreLabel.textColor = cardBackColor
        newGameButton.setTitleColor(cardBackColor, for: .normal)
    }
}

