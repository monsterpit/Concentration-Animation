//
//  CardBehavior.swift
//  ConcentrationAnimation
//
//  Created by Boppo on 23/04/19.
//  Copyright © 2019 MB. All rights reserved.
//

//Creating a UIDynamicBehavior subclass where we combine other once
//Combing our 3 differrentt behavior in VC Collison behavior ,item bahvior and push behavior
// It would be lot nicer if we had another behavior called CardBehavior and it had all those behavior as part of it and then we just add the card to the CardBehavior and we get the collision ,item and push behavior automatically
import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        
        behavior.translatesReferenceBoundsIntoBoundary = true
        
  //      animator.addBehavior(behavior)
        
        return behavior
    }()
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        
        //I dont want those things rotating around
        behavior.allowsRotation = false
        
        //I want elasticity
        // behavior.elasticity = 1.0 means collision don't lose any energy or gain energy .
        // if I set behavior.elasticity = 1.1 it will gain energy those things will circle faster and faster then you would forget
        //but if I said behavior.elasticity = 0.9 they gonna slow down
        // So behavior.elasticity = 1.0 is this kind of as most elasticity I can give it and not run into an accelerating situation
        behavior.elasticity = 1.0
        
        //which is how much it resist forces being applied on it and I am gonna set that to zero
        //i don't want any resistance I want to be kind of free flowing and here in outer space and not resisting anything
        behavior.resistance = 0
        
      //  animator.addBehavior(behavior)
        
        return behavior
        //so now we have to add items to itemBehavior to do it's thing
    }()
    
    private func push(_ item : UIDynamicItem){
      //  let push = UIPushBehavior(items: [cardView], mode: .instantaneous)
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        push.angle = (2*CGFloat.pi).arc4random
        
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        
        push.action = { [unowned push,weak self] in
            //push.dynamicAnimator?.removeBehavior(push)
            
            //Implicit use of 'self' in closure; use 'self.' to make capture semantics explicit
            //self.removeChildBehavior(push) is now capturing self which is the dynamicBehavior
            //we dont wanna do that because dynamicBehavior definitely has a pointer to push.action closure
            //Because it has a pointer to its own child behaviors of one which is a push behavior
            // and the push behavior points to it
            // so we gonna get rid of it by saying weak self
            // I dont wanna do unowned self there becaus just in case for some reason my whole behavior got removed from the heap I don't want to be crashing here so I am just gonna do weak to be little bit safe
            // It's not the same case where I know for a fact that this push has to be in the heap because I wouldn't have got here that's not necessarily true of self
            self?.removeChildBehavior(push)
        }
        
        addChildBehavior(push)
        
      //  animator.addBehavior(push)
    }
    
    func addItem(_ item : UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item : UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        // we dont have to remove push as we remove the push as soon as action happens
    }
    
    
// we have to add behavior in childrens in an init
    override init(){
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    // https://useyourloaf.com/blog/adding-swift-convenience-initializers/
    // https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID203
    convenience init(in animator : UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

