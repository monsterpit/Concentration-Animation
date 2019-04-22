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
        // viewDidLoad is a great place to initialize stuff or put debugging code or checking things out
    
    @IBOutlet weak var playingCardView : PlayCardView!{
        didSet{
            //since  swipe is going to flip through the cards it's going to affect the model.So its handled by by me the controller,So self is the target
            //view cant touch the model so there's no way it could do the swipe  and then the selector  can just be any function
            
            //Argument of '#selector' refers to instance method 'nextCard()' that is not exposed to Objective-C
            //Add '@objc' to expose this instance method to Objective-C
            //this whole mechanism is made on Objective C target action
            // So any method that going to be an action of a gesture recognizer has to be marked @objc
            //that exports this method out of swift into the Objective C runtime which underlines the running of iOS
            //Even with the swift code still got the objective C runtime
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left,.right]
            
            //saying playingCardView please start recognizing me
            playingCardView.addGestureRecognizer(swipe)
            // and now it will start recognizing
            
            //target is going to be playingCardView because it's gonna handle it directly.It's gonna handle directly.
            //It's not gonna go to the controller
            // and the selector is method in playingCardView
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            //adding gesture to view
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    @objc func nextCard(){
        if let card = deck.draw(){
            
            //controller is doing its job to converting between model and view
            playingCardView.rank = card.rank.order!
            playingCardView.suit = card.suit.rawValue
            
        }
    }
    
    //MARK:- Added from IB
    
    //can work with this only but not a proper way to do it
    //    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
    //        playingCardView.isFaceUp = !playingCardView.isFaceUp
    //    }

    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for _ in 1...10 {
            if let card = deck.draw(){
                print("\(card)")
            }
        }
    }



}

