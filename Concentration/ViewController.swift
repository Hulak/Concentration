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
    
    @IBAction func newGame(_ sender: UIButton) {
        game.resetGame()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
        flipCount = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = keys.count.arc4random
        updateViewFromModel()
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
    
    private var emojiThemes : [String: [String]] = [
        "Fruits" : ["🥥", "🍍", "🍉", "🍌", "🍑", "🍊", "🥝", "🍇", "🍒", "🍏", "🍓"],
        "Vegetables" : ["🍆", "🥦", "🥒", "🥕", "🥔", "🌽", "🥑", "🍠"],
        "Faces" : ["😃", "😘", "😍", "😇", "😎", "🤓", "😭", "😱", "😵", "🙄", "🤯"],
        "Animals" : ["🐶", "🐱", "🐭", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐸", "🐷", "🐵", "🦄"],
        "Nature" : ["🌿", "🍄", "🌹", "🌼", "🍁", "🌵", "🔥", "🌈", "🌪"],
        "Halloween" : ["🕷", "🕸", "👻", "💀", "🎃", "😈", "👺", "🤡", "🦇", "👽"],
        "Clothes" : ["👚", "👕", "👖", "👗", "👙", "👘", "👔", "👠", "🧤", "🧦", "🧢"],
        "Drinks" : ["🥛", "☕️", "🥤", "🍶", "🍺", "🍻", "🥂", "🍷", "🥃", "🍸", "🍹", "🍾", "🍵"]
    ]
    
    private var indexTheme = 0 {
        didSet {
            print(indexTheme, keys[indexTheme])
            emojis = emojiThemes[keys[indexTheme]] ?? []
            emoji = [Int: String] ()
        }
    }
    private var keys: [String] {return Array(emojiThemes.keys)}

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
extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: diff.arc4random)
            swapAt(i, j)
        }
    }
}
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

