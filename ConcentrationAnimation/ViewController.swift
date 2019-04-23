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

    lazy var animator = UIDynamicAnimator(referenceView: view)

    lazy var cardBehavior = CardBehavior(in: animator)
    
    
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
            
        //    collisionBehavior.addItem(cardView)
            
            //has soon as we add this it will have all those setting
          //  itemBehavior.addItem(cardView)
            
            cardBehavior.addItem(cardView)
            

            
            // the game is kinda easy it settles down quickly it settles down it kinda settles down too easily too quickly that's gonna make it too easy to play this game
            //all of those cards moving a little more
            // other thing I don't think I want them rotated it's kinda a fun to have them rotated actually
            // but when you flip the card for e.g. it doesn't flip along the axis of the drawing it flips along the axis of the view
            // so tilted cards flips around the corner may be that's okay but we are going to use dynamic item behavior
            //also the reason it is slowing down so much is there's not enough elasticity in the collision
            // So I want those collisions bouncing off and keeping energy up and we will do that with another kind of behavior
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
                                                
                                                self.faceUpCardViews.forEach{
                                                    //CGAffineTransform.identity no rotation
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                            },

                                            completion: { (position) in
                                                UIViewPropertyAnimator.runningPropertyAnimator(

                                                    withDuration: 0.75,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        
                                                        self.faceUpCardViews.forEach{
                                                         
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)

                                                            $0.alpha = 0
                                                        }
                                                },
                                                    //removing the card
                                                    completion: { position in
                                                        self.faceUpCardViews.forEach{
                                                            
                                                            //making card hidden
                                                            $0.isHidden = true
                                                            
                                                            //making alpha back to 1
                                                            $0.alpha = 1
                                                            
                                                            //scaling view back to identity
                                                            $0.transform = .identity
                                                        }
                                                })
                                        })
                                        
                                    }
                                    
                                    else if self.faceUpCardViews.count == 2{

                                        self.faceUpCardViews.forEach{ cardView in
   
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

extension CGFloat{
    var arc4random : CGFloat{
        if self > 0{ return CGFloat(arc4random_uniform(UInt32(self)))}
        else if (self  < 0) {   return -CGFloat(arc4random_uniform(UInt32(abs(self)))) }
        else {return 0}
    }
}
