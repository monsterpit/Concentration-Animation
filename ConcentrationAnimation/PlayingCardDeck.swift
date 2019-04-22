//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by MB on 4/11/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

struct PlayingCardDeck{
    
    private(set) var  cards = [PlayCard]()
    
    init(){
        //Swift allows nest type with e.g. PlayCard.Suit enum "Suit" in Struct
        for suit in PlayCard.Suit.all{
            for rank in PlayCard.Rank.all{
                cards.append(PlayCard(suit: suit, rank: rank))
            }
        }
    }
    
    // draws playing card out of the deck
    mutating func draw() -> PlayCard?{
        
        if cards.count > 0 {return cards.remove(at: cards.count.arc4random)}
        else {return nil}
        
    }
}


extension Int{
    var arc4random : Int{
        if self > 0{ return Int(arc4random_uniform(UInt32(self)))}
        else if (self  < 0) {   return -Int(arc4random_uniform(UInt32(abs(self)))) }
        else {return 0}
    }
}
