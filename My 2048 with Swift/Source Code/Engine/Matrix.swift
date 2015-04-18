//
//  Matrix.swift
//  My 2048 with Swift
//
//  Created by Vittorio Monaco on 09/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import Foundation

class Matrix {
    let size: Int
    var tiles: [Int]
    
    init(size: Int) {
        self.size = size
        tiles = [Int](count:size*size, repeatedValue:0)
    }
    
    subscript(index: Int, direction: Direction) -> [Int] {
        var sequence = [Int](count: size, repeatedValue:0)
        
        for i in 0..<size {
            sequence[i] = tiles[Matrix.realIndex(i, direction: direction, row: index, size: size)]
        }
        
        return sequence
    }
    
    class func realIndex(i: Int, direction: Direction, row index: Int, size: Int) -> Int {
        switch direction {
            case .Right:
                return i + (index * size)
            case .Left:
                return size-i-1 + (index * size)
            case .Down:
                return (size * i) + index
            case .Up:
                return size*size - (size - index ) - (size * i)
        }
    }
    
    func compact(sequence: [Int], row: Int, let direction: Direction, changeset: Changeset) -> ([Int], Changeset) {
        var current = count(sequence) - 1
        var minFreeSpace = current
        var out = sequence
        
        do {
            while current >= 0 && out[current] == 0 {
                current--
            }
            
            if current < 0 {
                break
            }
            if minFreeSpace != current {
                let oldValue = Matrix.realIndex(current, direction: direction, row: row, size: size)
                let newValue = Matrix.realIndex(minFreeSpace, direction: direction, row: row, size: size)
                
                //Check if a previous move to update is present
                let existingMove = changeset.changes.filter({ (element: Change) in
                    element.type == ChangeType.MoveTile && element.afterChange == oldValue
                    })
                if count(existingMove) > 0 {
                    let oldMove = existingMove[0]
                    let newMove = Change(oldValue: oldMove.beforeChange, newValue: newValue, changeType: .MoveTile)
                    let oldIndex = changeset.removeChange(oldMove)
                    changeset.insertChange(newMove, atIndex: oldIndex)
                }
                
                //Check if oldValue is target of some existing merge
                let existingMerge = changeset.changes.filter({ (element: Change) in
                    element.type == ChangeType.MergeTiles && element.afterChange == oldValue
                    })
                if count(existingMerge) > 0 {
                    let oldMerge = existingMerge[0]
                    let newMerge = Change(oldValue: newValue, newValue: newValue, changeType: .MergeTiles)
                    let oldIndex = changeset.removeChange(oldMerge)
                    changeset.insertChange(newMerge, atIndex: oldIndex)
                }
                
                changeset.addChanges([ Change(oldValue: oldValue, newValue: newValue, changeType: .MoveTile) ])
                
                let temp = out[current]
                out[current] = 0
                out[minFreeSpace] = temp
            }
            current = --minFreeSpace
        } while current >= 0
        
        return (out, changeset)
    }
    
    func merge(sequence: [Int], row: Int, let direction: Direction, changeset oldChangeset: Changeset) -> ([Int], Changeset) {
        var out = sequence
        
        for i in 0..<(out.count - 1) {
            let index = (out.count - 1) - i
            
            if out[index] != 0 && out[index] == out[index-1] {
                out[index] *= 2
                out[index-1] = 0
                
                var realIndex = Matrix.realIndex(index, direction: direction, row: row, size: size)
                
                //Merge existing compact if any
                let oldValue = Matrix.realIndex(index - 1, direction: direction, row: row, size: size)
                let existingSource = oldChangeset.changes.filter({ ( element: Change) in
                    return element.afterChange == oldValue
                    })
                if count(existingSource) == 1 {
                    let oldIndex = oldChangeset.removeChange(existingSource[0])
                    oldChangeset.insertChange(Change(oldValue: existingSource[0].beforeChange, newValue: realIndex, changeType: .MoveTile), atIndex: oldIndex)
                }
                
                oldChangeset.addChanges([Change(oldValue: realIndex, newValue: realIndex, changeType: .MergeTiles)])
            }
        }
        
        return (out, oldChangeset)
    }
    
    func update(index: Int, direction: Direction) -> Changeset {
        var sequence = self[index, direction]
        var previousSequence = sequence
        var changeset = Changeset()
        
        (sequence, changeset) = compact(sequence, row: index, direction: direction, changeset: changeset)
        (sequence, changeset) = merge(sequence, row: index, direction: direction, changeset: changeset)
        (sequence, changeset) = compact(sequence, row: index, direction: direction, changeset: changeset)
        
        for i in 0..<sequence.count {
            tiles[Matrix.realIndex(i, direction: direction, row: index, size: size)] = sequence[i]
        }
        
        return changeset
    }
    
    func noSpaceLeft() -> Bool {
        return count(tiles.filter({ (element: Int) in
            element == 0
        })) == 0
    }
    
    func addTile(value: Int) -> Changeset? {
        if noSpaceLeft() {
            return nil //Game over
        }
        
        var tileIndex = -1
        do {
            var value = arc4random_uniform((UInt32)(size) * (UInt32)(size))
            tileIndex = Int(value)
        } while tiles[tileIndex] != 0
        
        tiles[tileIndex] = value
        
        for row in 0..<size {
            println(self[row, .Right])
        }
        
        return Changeset(newTile: tileIndex)
    }
}