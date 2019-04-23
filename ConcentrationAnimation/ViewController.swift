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
        return cardViews.filter{$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1}
    }
    
    //bool to say if 2 faceUpCard Match
    private var faceUpCardViewsMatch : Bool {
        return faceUpCardViews.count == 2 &&
    faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
    faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    //starts nil as we wont have lastChosenCardView when we startup
    // and everytime we go through and choose a card we gonna remember our lastChosenCardView
    var lastChosenCardView : PlayCardView?
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        // first thing we always do is switch on recognizer state
        switch recognizer.state{
        case .ended:
            // because if already have 2 matching cards that are expanding and growing out then we obviously can t match anymore so that would kinda work except for that you could imagine that if I had a match and the cards that are expanding out that it might actually want to start working on my next pair and so for that to work we really wanna have those 2 matching cards not really count as faceup cards at all
            if let chosenCardView = recognizer.view as? PlayCardView,faceUpCardViews.count < 2{
                
                lastChosenCardView = chosenCardView
                
                //removing item
                cardBehavior.removeItem(chosenCardView)
                
                UIView.transition(with: chosenCardView,
                                  duration: 3.0,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                                   },

                                  completion: { finished in
                                    
                                    //when we go into our animation we look for which cards are face up by calling  self.faceUpCardViews
                                    // well this thing is dynamically always calculating the cards that are faceUp so if we have a animation here and it starts off and it's going and then it tries to do its second part it looks for the faceUp cards again when in fact we just want this entire animation to apply to the original 2  cards that were chosen
                                    //so we can capture that by just having a little local variable here I'm going to call it cardsToAnimate = self.faceUpCardViews
                                    // so we are capturing it here and gonna use it everywhere 
                                    let cardsToAnimate = self.faceUpCardViews
                                    
                                    if self.faceUpCardViewsMatch{
                                        //MARK:- UIViewPropertyAnimator
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                
                                                cardsToAnimate.forEach{
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
                                                        
                                                        cardsToAnimate.forEach{
                                                         
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)

                                                            $0.alpha = 0
                                                        }
                                                },
                                                    //removing the card
                                                    completion: { position in
                                                        cardsToAnimate.forEach{
                                                            
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
                                        
                                        if chosenCardView == self.lastChosenCardView
                                        {
                                        cardsToAnimate.forEach{ cardView in
   
                                            UIView.transition(with: cardView,
                                                              duration: 3.0,
                                                              options: .transitionFlipFromLeft,
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            },
                                                              completion: {finished in
                                                                //so does this cause a memory cycle no because these are animation closure
                                                                self.cardBehavior.addItem(cardView)
                                            })
                                        }
                                    }
                                    }
                                    else {
                                        if !chosenCardView.isFaceUp {
                                            self.cardBehavior.addItem(chosenCardView)
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
        return self * (CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max))
    }
}
//When you tap 3 cards continuously there is a wacky  animation
//well what's happening here is both the original card that we flipped up and the second card are both trying to flip the 2 cards face down
//So those 2 transforms modification in else if self.faceUpCardViews.count == 2
//they are both trying to operate on cards at the same time
//When something happens in the middle of transform and another transform comes along  its basically messing up the whole transform
//Now there is a easy fix for these we just let the latset card that was chosen control the animation
//That way they will never interfere with eachother because second one comes along and chooses it gets to do the animation
// track of  var lastChosenCardView : PlayCardView?
