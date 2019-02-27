//
//  BorderButton.swift
//  Set
//
//  Created by Рыжков Артем on 26/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

@IBDesignable class BorderButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = DefaultValues.borderColor  {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = DefaultValues.borderWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = DefaultValues.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
    
    // Constants
    private struct DefaultValues {
        static let borderWidth: CGFloat = 5.0
        static let borderColor: UIColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        static let cornerRadius: CGFloat = 8.0
    }
}
