//
//  ViewController.swift
//  Set
//
//  Created by Рыжков Артем on 26/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    var verticalSizeClass: UIUserInterfaceSizeClass = .regular

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // updateButtonsFromModel()
    }

    private func updateButtonsFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle(String (index), for: .normal)
            if index < 12 {
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }

}

