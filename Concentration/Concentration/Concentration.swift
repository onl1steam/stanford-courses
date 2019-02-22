//
//  Concentration.swift
//  Concentration
//
//  Created by Рыжков Артем on 17/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private(set) var score = 0
    private var seenCards: Set<Int> = []
    
    private var dateClick: Date?
    private var timePenalty: Int {
        return min(dateClick?.sinceNow ?? 0, Points.maxTimePenalty)
    }
    
    private(set) var flipCount = 0
    
    struct Points {
        static let matchBonus = 20
        static let missMatchPenalty = 5
        static let maxTimePenalty = 10
    }
    
    private var indexOfOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    guard foundIndex == nil else { return nil }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)) : Choosen index out of range")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    // cards match
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    // increase score
                    score += Points.matchBonus
                } else {
                    // cards didn't match - Penalize
                    if seenCards.contains(index){
                        score -= Points.missMatchPenalty
                    }
                    if seenCards.contains(matchIndex){
                        score -= Points.missMatchPenalty
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                score -= timePenalty
                cards[index].isFaceUp = true
            } else {
                indexOfOnlyFaceUpCard = index
            }
            flipCount += 1
            dateClick = Date()
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    func resetGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        seenCards = []
        flipCount = 0
        score = 0
        cards.shuffle()
    }
}

extension Date {
    var sinceNow: Int {
        return -Int(self.timeIntervalSinceNow)
    }
}
