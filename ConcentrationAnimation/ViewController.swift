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
    
    //bool to say if 2 faceUpCard Match
    private var faceUpCardViewsMatch : Bool {
        return faceUpCardViews.count == 2 &&
    faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
    faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        // first thing we always do is switch on recognizer state
        switch recognizer.state{
        case .ended:
    
            if let chosenCardView = recognizer.view as? PlayCardView{
                
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                                   },

                                  completion: { finished in
                                    if self.faceUpCardViewsMatch{
                                        //MARK:- UIViewPropertyAnimator
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                //Only thing I can change in here is those view properties if i change anything else it will do it but it's not going to affect the animation in anyway
                                                // so what are the animations you wanna do here?
                                                // well we want all the faceUpCard get really big I am gonna do that with transform it's really easyy to make things big or rotate them
                                                
                                                self.faceUpCardViews.forEach{
                                                    //CGAffineTransform.identity no rotation
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                            },
                                            // completion has UIViewAnimatingPosition which has position which is either .end .start .current
                                            // we dont care about it as we dont have animations that are gonna be jumping on top of eaachother here so it's not a problem
                                            // so here we want another PropertyAnimator
                                            completion: { (position) in
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    //withDuration should be longer than 0.6 because we went from identity transform to 3.0 and now I am going from 3.0 past identity down to 0.1 maybe I want to give it a little extra time go that extra distance it feels like it's coming  out and in same time
                                                    withDuration: 0.75,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        
                                                        self.faceUpCardViews.forEach{
                                                         
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                            // fully transparent remember this is gonna happen immediately gonna set to zero but the user is going to see it over te course of withDuration
                                                            $0.alpha = 0
                                                        }
                                                })
 //                                               ,
//
//
//                                                    //removing the card
//                                                    completion: { (<#UIViewAnimatingPosition#>) in
//                                                        <#code#>
//                                                })
                                        })
                                        
                                    }
                                    
                                    else if self.faceUpCardViews.count == 2{

                                        self.faceUpCardViews.forEach{ cardView in
                                            //chosenCardView == $0
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: .transitionFlipFromLeft,
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            },
                                                              completion: {finished in
                                                                
                                            })
                                        }
                                        

                                    }
                })
                
                
            }
        default:
            break
        }
    }



}

