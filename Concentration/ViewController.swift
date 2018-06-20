//
//  ViewController.swift
//  Concentration
//
//  Created by Alyona Hulak on 6/9/18.
//  Copyright © 2018 Alyona Hulak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game: Concantration = Concantration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
        get {
            return ((cardButtons.count + 1) / 2)
        }
    }
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip: \(flipCount)"
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9333558058, green: 0.1533911533, blue: 0.1850080983, alpha: 1)
            }
        }
    }
    
    private var emojis = ["🥥", "🥑", "🍍", "🍉", "🍌", "🍑", "🍊", "🥝", "🍇", "🍒"]
    
    private var emoji = [Int: String]()
    
    private func emoji(for card: Card) -> String {
      
        if emoji[card.identifier] == nil, emojis.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojis.count - 1)))
            emoji[card.identifier] = emojis.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

