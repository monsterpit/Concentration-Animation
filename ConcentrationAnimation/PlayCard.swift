//
//  PlayCard.swift
//  PlayCard
//
//  Created by MB on 4/11/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

//CustomStringConvertible protocol is used to print output nicely
//e.g. PlayCard(suit: PlayingCard.PlayCard.Suit.hearts, rank: PlayingCard.PlayCard.Rank.face("Q")) To card is of hearts and 12

struct PlayCard : CustomStringConvertible{
    var description: String {
        return "\(suit) \(rank)"
    }
    
    
    var suit : Suit
    var rank : Rank

    // raw values in enum , it turns out that you can associate a fixed constant raw value for every one of your cases.Swift will even do some of this automatically .
    //e.g.
    //    enum Suit : Int{
    //        case spades
    //        case hearts
    //        case diamonds
    //        case clubs
    //    }
    //    will make Suit raw value start from 0 i.e spades = 0, hearts = 1 , diamaonds = 2 , clubs = 3 so it goes in order the "lexical order" which appears in the file. if string "spades"
    // why would you want raw value mostly for backwards compatibility with Objective C enums
    // because in Obj C enums were essentially ints , 0,1,2,3.... so the raw value is raw value int
    // but could imagine it might be interesting if there is some piece of data that it makes sense to associate with all the cases. And again it has be fixed and constant and unique. For all the cases
    enum Suit : String,CustomStringConvertible {
        
        
        case spades    = "♠️"
        case diamonds  = "♦️"
        case hearts    = "♥️"
        case clubs     = "♣️"
        
        //returns all Suits
        static var all : [Suit] = [Suit.spades,.diamonds,.hearts,.clubs]
        
        var description: String {return rawValue}

    }
    //enum Rank { before
    //card is of spades and numeric(2)
    //enum Rank : CustomStringConvertible
    //card is of spades and 2
    enum Rank : CustomStringConvertible{

        
        case ace
        // enums associated data
        case face(String)
        case numeric(Int)
        
        var order : Int?{
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
                //  case .face(let kind):
                //                if kind == "J" {return 11}
                //                else if kind == "Q" {return 12}
                //                else {return 13}
                // instead we can do is  where
                //this stuff with case switches was a pattern matching language check docs for it
            // but one of things it can do is where
                //where makes it we dont count every possible value so we have default
            case .face(let kind) where kind=="J": return 11
            case .face(let kind) where kind=="Q": return 12
            case .face(let kind) where kind=="K": return 13

            default:
                return nil
            }
        }
        
        //static becuase talking about all not one
        static var all : [Rank]{
            var allRanks = [Rank.ace]
            for pip in 2...10{
                allRanks.append(Rank.numeric(pip))
            }
            
             // once given Rank.face it can swift can infer rest
            allRanks += [Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
        
        
        
        var description: String {
            switch self {
            case .ace:
                return "A"
            case .numeric(let pips) : return String(pips)
            case . face(let kind) : return kind
                
            }
        }
    }
    
}
