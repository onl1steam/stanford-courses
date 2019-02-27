//
//  ViewController.swift
//  Set
//
//  Created by Рыжков Артем on 26/02/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [BorderButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonsFromModel()
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

