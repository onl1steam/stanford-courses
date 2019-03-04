//
//  ViewController.swift
//  Set
//
//  Created by Рыжков Артем on 26/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = SetGame()
    
    enum Player: Int {
        case me = 1
        case iPhone
    }
    
    private var currentPlayer = Player.me {
        didSet {
            game.playerIndex = currentPlayer.rawValue - 1
        }
    }
    
    var verticalSizeClass: UIUserInterfaceSizeClass = .regular
    
    @IBOutlet weak var deckCountLabel: UILabel!
    // -------------- ME ----------------
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    // -------------- IPHONE ---------------
    @IBOutlet weak var messageIPhoneLabel: UILabel!
    @IBOutlet weak var iPhoneLabel: UILabel!
    @IBOutlet weak var scoreIPhoneLabel: UILabel!
    
    
    @IBOutlet weak var hintButton: BorderButton!
    @IBOutlet weak var dealButton: BorderButton!
    @IBOutlet weak var newButton: BorderButton!
    
    private var _lastHint = 0
    private weak var timer: Timer?
    private weak var timer1: Timer?
    
    var strokeWidths: [CGFloat] = [-10, 10, -10]
    var colors: [UIColor] = [#colorLiteral(red: 1, green: 0.4163245823, blue: 0, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)]
    var alphas: [CGFloat] = [1.0, 0.60, 0.15]
    
    @IBOutlet var cardButtons: [SetCardButton]! {
        didSet {
            for button in cardButtons {
                button.strokeWidths = strokeWidths
                button.colors = colors
                button.alphas = alphas
            }
        }
    }
    
    @IBAction func deal3() {
        if (game.cardsOnTable.count + 3) <= cardButtons.count {
            currentPlayer = .me
            game.deal3()
            updateViewFromModel()
            timer1?.invalidate()
        }
    }
    
    @IBAction func newGame() {
        timer?.invalidate()
        timer1?.invalidate()
        game = SetGame()
        currentPlayer = Player.me
        cardButtons.forEach { $0.setCard = nil }
        updateViewFromModel()
    }
    
    @IBAction func hint() {
        timer?.invalidate()
        if game.hints.count > 0 {
            game.hints[_lastHint].forEach { (idx) in
                let button = self.cardButtons[idx]
                button.setBorderColor(color: Colors.hint)
            }
            messageLabel.text = "Set \(_lastHint + 1) Wait..."
            timer = Timer.scheduledTimer(withTimeInterval: Constants.flashTime, repeats: false) {
                [weak self] time in
                self?.game.hints[(self?._lastHint)!].forEach{ (idx) in
                    let button = self?.cardButtons[idx]
                    button!.setBorderColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                }
                self?._lastHint = (self?._lastHint)!.incrementCicle(in: (self?.game.hints.count)!)
                self?.messageLabel.text = ""
                self?.updateViewFromModel()
            }
            
        }
    }
    
    @IBAction func touchCard(_ sender: SetCardButton) {
        timer1?.invalidate()
        currentPlayer = .me
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            if let itIsSet = game.isSet, itIsSet {
                TryiPhone()
            }
        } else {
            print("Choosen card was not in cardButtons")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func TryiPhone() {
        // TryiPhone
        iPhoneLabel.text = "  🤔  "
        iPhoneLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        timer1 = Timer.scheduledTimer(withTimeInterval: Constants.iPhoneWaitTime, repeats: false){
            [weak self] time in
            
            self?.currentPlayer = .iPhone
            self?.iPhoneLabel.text = "  😀  "
            self?.iPhoneLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            
            // neutralize Set from .me
            self?.neutralizationSet()
            
            // remove selected cards
            self?.removeSelectedCards()
            
            // flip a coin with probability 2/3
            if Int.randomNumber(probabilities: [1, 2]) == 1 {
                // success hint set
                self?.selectHintSet()
            } else {
                // fail random set
                self?.selectRandomSet()
            }
            
            self?.updateViewFromModel()
            if let itIsSet = self?.game.isSet {
                self?.iPhoneLabel.text = itIsSet ? "  😂!!!" : "  😥..."
            } else {
                self?.iPhoneLabel.text = "🤢 No Sets at all."
            }
            
        }
    }
    
    private func updateButtonsFromModel() {
        messageLabel.text = ""
        messageIPhoneLabel.text = ""
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            // Card on cardboard
            if index < game.cardsOnTable.count {
                let card = game.cardsOnTable[index]
                button.setCard = card
                // Selected
                button.setBorderColor(color: game.cardsSelected.contains(card) ? Colors.selected : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                // TryMatched
                if let itIsSet = game.isSet {
                    if game.cardsTryMatched.contains(card) {
                        button.setBorderColor(color: itIsSet ? Colors.matched : Colors.misMatched)
                    }
                    switch(currentPlayer) {
                    case .me :
                        messageLabel.text = itIsSet ? "Match!" : "Miss!"
                    case .iPhone:
                        messageIPhoneLabel.text = itIsSet ? "OK!!!" : "NO..."
                    }
                }
                
            } else {
                button.setCard = nil
            }
        }
    }
    
    private func updateViewFromModel() {
        updateButtonsFromModel()
        updateHintButton()
        deckCountLabel.text = "Deck: \(game.deckCount)"
        
        scoreLabel.text = "Score: \(game.score[0]) / \(game.numberSets[0])"
        scoreIPhoneLabel.text = "Score: \(game.score[1]) / \(game.numberSets[1])"
        
        dealButton.disable = (game.cardsOnTable.count) >= cardButtons.count || game.deckCount == 0
        hintButton.disable = game.hints.count == 0
    }
    
    private func updateHintButton() {
        hintButton.setTitle("\(game.hints.count) sets", for: .normal)
        _lastHint = 0
    }
    
    // MARK: Actions for iPhone
    // neutralize Set from .me
    private func neutralizationSet() {
        var cardsOnTable = game.cardsOnTable
        cardsOnTable.remove(elements: game.cardsTryMatched)
        let randomCard = cardsOnTable [Int.random(in: 0..<cardsOnTable.count)]
        if let randomIndex = game.cardsOnTable.index(of: randomCard) {
            game.chooseCard(at: randomIndex)
        }
        
    }
    
    // remove selected cards
    private func removeSelectedCards() {
        game.cardsSelected.forEach { card in
            if let idx = game.cardsOnTable.index(of: card) {
                game.chooseCard(at: idx)
            }
        }
    }
    
    // success hint set
    private func selectHintSet() {
        if game.hints.count > 0 {
            game.hints[0].forEach { idx in
                game.chooseCard(at: idx)
            }
        }
    }
    
    // fail random set
    private func selectRandomSet() {
        var cardsOnTable = game.cardsOnTable
        cardsOnTable.shuffle()
        for index in 0..<3 {
            if let idx = game.cardsOnTable.index(of: cardsOnTable[index]) {
                game.chooseCard(at: idx)
            }
        }
    }
}

extension SetGameViewController {
    // Constants
    
    private struct Colors {
        static let hint = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        static let selected = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        static let matched = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        static let misMatched = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private struct Constants {
        static let flashTime = 1.5
        static let iPhoneWaitTime = 2.0
    }
}

extension Int {
    func incrementCicle(in number: Int) -> Int {
        return (number - 1) > self ? self + 1 : 0
    }
    
    static func randomNumber(probabilities: [Int]) -> Int {
        
        // Sum of all probabilities
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum
        let rnd = Int.random(in: 0..<sum)
        // Find the first interval of accumulated probabilities into which 'rnd' fails
        var accum = 0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        return (probabilities.count - 1)
    }
}
