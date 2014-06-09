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
    
    func addChanges(changes: Change[]) {
        self.changes += changes
    }
    
    init() {
        changes = Change[]()
    }
    
    init(previousSequence: Int[], nextSequence: Int[], direction: Direction, row i: Int) {
        changes = Change[]()
        
        //Generate changes in row and for each of them create a new Change instance with the oldPosition in the sequence and the new one.
        //The board will do the calculations on the frames
        var changedIndexes: Int[] = Int[]()
        for idx in 0..countElements(previousSequence) {
            if previousSequence[idx] != nextSequence[idx] {
                let size = countElements(previousSequence)
                var realIndex = Matrix.realIndex(idx, direction: direction, row: i, size: size)

                changedIndexes += realIndex
            }
        }
        
        println("Changed indexes: " + changedIndexes.description)
        
        if countElements(changedIndexes) > 1 {
            for var change = countElements(changedIndexes) - 2; change >= 0; --change {
                changes += Change(oldValue: changedIndexes[change], newValue: changedIndexes[change + 1], changeType: .MoveTile)
            }
        }
        
        changes = changes.reverse()
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