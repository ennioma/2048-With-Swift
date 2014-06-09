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
    
    func reverse() -> Changeset {
        changes = changes.reverse()
        return self
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
    
    func description() -> String {
        return "{ Old value: \(beforeChange), new value: \(afterChange), type: \(type.toRaw()) }"
    }
}