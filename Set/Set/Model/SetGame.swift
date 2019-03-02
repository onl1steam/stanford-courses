//
//  SetGame.swift
//  Set
//
//  Created by Рыжков Артем on 27/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var cardsOnTable = [SetCard]()
    private(set) var cardsSelected = [SetCard]()
    private(set) var cardsTryMatched = [SetCard]()
    private(set) var cardsRemoved = [SetCard]()
    
    private(set) var score = 0
    private(set) var flipCount = 0
    private(set) var numberSets = 0
    
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else { return nil }
            return SetCard.isSet(cards: cardsTryMatched)
        }
        set {
            if newValue == nil {
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            }
            cardsTryMatched.removeAll()
        }
    }
    
    private var deck = SetCardDeck()
    var deckCount: Int {
        return deck.cards.count
    }
    
    mutating func chooseCard(at index: Int) {
        // Index check
        assert(cardsOnTable.indices.contains(index), "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
        
        let cardChoosen = cardsOnTable[index]
        if !cardsRemoved.contains(cardChoosen) && !cardsTryMatched.contains(cardChoosen) {
            if isSet != nil {
                if isSet! { replaceOrRemove3Cards() }
                isSet = nil
            }
            if cardsSelected.count == 2 && !cardsSelected.contains(cardChoosen) {
                cardsSelected += [cardChoosen]
                isSet = SetCard.isSet(cards: cardsSelected)
            } else {
                cardsSelected.inOut(element: cardChoosen)
            }
            flipCount += 1
            score -= Points.flipOverPenalty
        }
    }
    
    private mutating func take3FromDeck() -> [SetCard]? {
        var threeCards = [SetCard]()
        for _ in 0...2 {
            if let card = deck.draw() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }
    
    mutating func deal3() {
        if let deal3Cards = take3FromDeck() {
            cardsOnTable += deal3Cards
        }
    }
    
    private mutating func replaceOrRemove3Cards() {
        if let take3Cards = take3FromDeck() {
            cardsOnTable.replace(elements: cardsTryMatched, with: take3Cards)
        } else {
            cardsOnTable.remove(elements: cardsTryMatched)
        }
        cardsRemoved += cardsTryMatched
        cardsTryMatched.removeAll()
    }
    
    
    
    
    // --------------Constants-------------
    private struct Points {
        static let flipOverPenalty = 1
        static let matchBonus = 20
        static let missMatchPenalty = 10
        static let maxTimePenalty = 10
    }
    
    private struct Constants {
        static let startNumberCards = 12
    }
    
    
}

extension Array where Element: Equatable {
    // Toggle element presence in array
    mutating func inOut(element: Element) {
        if let from = self.index(of: element) {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }
    
    mutating func remove(elements: [Element]) {
        // Delete array of elemets from array
        self = self.filter { !elements.contains($0) }
    }
    
    mutating func replace(elements: [Element], with new: [Element]) {
        // Replace elements of array with new
        guard elements.count == new.count else {return}
        for idx in 0..<new.count {
            if let indexMatched = self.index(of: elements[idx]) {
                self [indexMatched] = new[idx]
            }
        }
    }
    
    func indices(of elements: [Element]) -> [Int] {
        guard self.count >= elements.count, elements.count > 0 else {return []}
        // Find indexes of elements
        return elements.map{self.index(of: $0)}.compactMap{$0}
    }
}
