//
//  SetCardButton.swift
//  Set
//
//  Created by Рыжков Артем on 02/03/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

@IBDesignable class SetCardButton: BorderButton {
    
    var colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)]
    var symbols = ["●", "▲", "■"]
    var strokeWidths: [CGFloat] = [-8, 8, -8]
    var alphas: [CGFloat] = [1.0, 0.40, 0.15]
    
    var setCard: SetCard? = SetCard(number: SetCard.Variant.v3,
                                    color: SetCard.Variant.v3,
                                    shape: SetCard.Variant.v3,
                                    fill: SetCard.Variant.v3){
        didSet {
            updateButton()
        }
    }
    
    private var verticalSizeClass: UIUserInterfaceSizeClass {
        return UIScreen.main.traitCollection.verticalSizeClass
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func setBorderColor(color: UIColor) {
        borderColor = color
        borderWidth = Constants.borderWidth
    }
    
    private func configure() {
        borderWidth = -Constants.borderWidth
        borderColor = Constants.borderColor
        cornerRadius = Constants.cornerRadius
        titleLabel?.numberOfLines = 0
    }
    
    private func updateButton() {
        if let card = setCard {
            let attributedString = setAttributedString(card: card)
            setAttributedTitle(attributedString, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            isEnabled = true
        } else {
            setAttributedTitle(nil, for: .normal)
            setTitle(nil, for: .normal)
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isEnabled = false
        }
    }
    
    private func setAttributedString(card: SetCard) -> NSAttributedString {
        // symbols: numbers & shape
        let symbol = symbols [card.shape.idx]
        let separator = verticalSizeClass == .regular ? "\n" : " "
        let symbolString = symbol.join(n: card.number.rawValue, with: separator)
        // attributes color and fill
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: colors[card.color.idx],
            .strokeWidth: strokeWidths[card.fill.idx],
            .foregroundColor: colors[card.color.idx].withAlphaComponent(alphas[card.fill.idx])
        ]
        return NSAttributedString(string: symbolString, attributes: attributes)
    }
    
    // ----------Constants----------
    private struct Constants {
        static let borderWidth: CGFloat = 5.0
        static let cornerRadius: CGFloat = 8.0
        static let borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}

extension String {
    func join(n: Int, with separator: String) -> String {
        guard n > 1 else {return self}
        var symbols = [String]()
        for _ in 0..<n {
            symbols += [self]
        }
        return symbols.joined(separator: separator)
    }
}
