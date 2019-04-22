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
            
            // target this is the object that is going to be sent this action method when the gesture happens
            // So we are gonna have target to be self the viewcontroller but it could be view , we could send it to view as well
            //this selector is just hash tag selector and then inside here you put the name of the method but only the external names of the arguments
            // we gonna have flip card with only 1 argument which is tapGesture with no external name so we gonna have _ : but nothing else
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        // first thing we always do is switch on recognizer state
        switch recognizer.state{
        case .ended:
            //but if i get a tap what i wanna do is get the card that was tapped on but I'm in my view controller
            //now normally I might have the target have been the view so it would know that it was itself that got tapped on but here I'm in the view controller so I have to find it
            // well it turn's out UITapGestureRecognizer it knows what view was tapped on
            //remember I said each of the concrete gesture have information about what happened well one of the things is they know what they were tapped on or whatever
            // so view is a var on UITapGestureRecognizer which is the view that was tapped on
            
            // casting as? PlayCardView because recognizer.view is just a UIView ofcourse UITapGestureRecognizer doesn't know anything about PlayCardView . I have to make sure that it is a fact a PlayCardView it should be because that's the only thing I added any of these tap gestures to
    
            if let chosenCardView = recognizer.view as? PlayCardView{
                chosenCardView.isFaceUp = !chosenCardView.isFaceUp
            }
        default:
            break
        }
    }



}

