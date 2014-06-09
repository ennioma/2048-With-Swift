//
//  Changeset.swift
//  My 2048 with Swift
//
//  Created by Vittorio Monaco on 08/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import Foundation

enum ChangeType: Int {
    case NewTile = 0
    case MoveTile
    case MergeTiles
}

class Changeset : NSObject {
    var changes: Change[]
    
    func addChanges(changes: Change[]) -> Changeset {
        self.changes += changes
        return self
    }
    
    func insertChange(change: Change, atIndex idx: Int) -> Changeset {
        changes.insert(change, atIndex: idx)
        println("inserting change \(change.description())")
        return self
    }
    
    func removeChange(change: Change) -> Int {
        var found = -1
        for idx in 0..countElements(changes) {
            let element = changes[idx]
            if change.equals(element) {
                found = idx
                break
            }
        }
        
        if found != -1 {
            changes.removeAtIndex(found)
            println("removing change \(change.description())")
        }
        
        return found
    }
    
    init() {
        changes = Change[]()
    }
    
    init(newTile: Int) {
        let change = Change(oldValue: -1, newValue: newTile, changeType: ChangeType.NewTile)
        changes = [change]
    }
    
    func description() -> String {
        var building = "Changes:\n"
        for i in 0..countElements(changes) {
            building += changes[i].description() + "\n"
        }
        
        return building
    }
}

class Change {
    let beforeChange: Int
    let afterChange: Int
    let type: ChangeType
    
    init(oldValue: Int, newValue: Int, changeType: ChangeType) {
        beforeChange = oldValue
        afterChange = newValue
        type = changeType
    }
    
    func equals(element: Change) -> Bool {
        return (beforeChange == element.beforeChange && afterChange == element.afterChange && type == element.type)
    }
    
    func description() -> String {
        return "{ Old value: \(beforeChange), new value: \(afterChange), type: \(type.toRaw()) }"
    }
}