//
//  ViewController.swift
//  PlayingCard
//
//  Created by MB on 4/11/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()

    @IBOutlet private var cardViews : [PlayCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cards = [PlayCard]()
        
        for _ in 1...((cardViews.count+1)/2) {
            if let card = deck.draw(){
            cards += [card,card]
            }
        }
        
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order!
            cardView.suit = card.suit.rawValue
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        // first thing we always do is switch on recognizer state
        switch recognizer.state{
        case .ended:
    
            if let chosenCardView = recognizer.view as? PlayCardView{
                
                //from to is when you are transitioning from one view to completely different view
                //that is you remove 1 from superview and add another one in as a subview
                // so similiar thing but it's like a card where the back of the card is one view and front of the card is different view
                
                //but here we are transitioning with the same view because we can turn it face up and face down
                
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                } )
               //  ,                                 completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                
                
            }
        default:
            break
        }
    }



}

