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
    
    private var faceUpCardViews : [PlayCardView]{
        return cardViews.filter{$0.isFaceUp && !$0.isHidden}
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
                                   },
                                  // It's perfectly fine to have animations in completion handler of other animations
                                  completion: {finished in
                                    
                                    //Reference to property 'faceUpCardViews' in closure requires explicit 'self.' to make capture semantics explicit
                                    //swift is saying wait a second bud you are accessing a var on yourself that's gonna capture yourself and I want you to type self. right there so that you realize that you might have loop here a memory cycle
                                    //because otherwise it is really easy to forget oops this is self and then realize oh I got a memory cycle
                                    //but do we have a memory cycle here?
                                    //no we don't
                                    //because while this closure does capture self
                                    //self doesn't in any way point to this closure
                                    //it's not part of any var it's not part of any dictionary or anything that self has
                                    //it's a closure we are giving off to the animation system so only the animation system has a  pointer to it.So there is no cycle here
                                    //so no reason for us to do any of those weird local variables
                                    
                                    if self.faceUpCardViews.count == 2{
                                        
                                        
                                    UIView.transition(with: chosenCardView,
                                                      duration: 0.6,
                                                      options: .transitionFlipFromLeft,
                                                      animations: {
                                                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                                    },
                                                      completion: {finished in
                                                        
                                    })
                                    }
                })
                
                
            }
        default:
            break
        }
    }



}

