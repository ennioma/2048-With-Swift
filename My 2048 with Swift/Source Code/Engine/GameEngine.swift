//
//  GameEngine.swift
//  My 2048 with Swift
//
//  Created by Ennio Masi on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import UIKit

protocol EngineProtocol {
    func updateBestScore(score: Int)
    func updateCurrentScore(score: Int)
    func updateTiles(changesets: Changeset)
}

enum Direction {
    case Up
    case Right
    case Down
    case Left
}

class Matrix {
    let size: Int
    var tiles: Int[]
    
    init(size: Int) {
        self.size = size
        tiles = Int[](count:size*size, repeatedValue:0)
    }
    
    subscript(index: Int, direction: Direction) -> Int[] {
        var sequence = Int[](count: size, repeatedValue:0)
        
        for i in 0..size {
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
    
    func compact(sequence: Int[], row: Int, let direction: Direction) -> (Int[], Changeset) {
        var current = countElements(sequence) - 1
        var changeset = Changeset()
        var minFreeSpace = current
        var out = sequence
        out.unshare()
        
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
                changeset.addChanges([ Change(oldValue: oldValue, newValue: newValue, changeType: .MoveTile) ])
                
                let temp = out[current]
                out[current] = 0
                out[minFreeSpace] = temp
            }
            current = --minFreeSpace
        } while current >= 0
        
        return (out, changeset.reverse())
    }
    
    func merge(sequence: Int[], row: Int, let direction: Direction, changeset oldChangeset: Changeset) -> (Int[], Changeset) {
        var out = sequence.copy()
        
        for i in 0..(out.count - 1) {
            let index = (out.count - 1) - i
            
            if out[index] != 0 && out[index] == out[index-1] {
                out[index] *= 2
                
                if index - 2 > 0 {
                    out[index-1] = out[index-2]
                    out[index-2] = 0
                } else {
                    out[index-1] = 0
                }

                var realIndex = Matrix.realIndex(index, direction: direction, row: row, size: size)
                
                //Merge existing compact if any
                let oldValue = Matrix.realIndex(index - 1, direction: direction, row: row, size: size)
                let existingSource = oldChangeset.changes.filter({ ( element: Change) in
                        return element.afterChange == oldValue
                    })
                if countElements(existingSource) == 1 {
                    oldChangeset.addChanges([Change(oldValue: existingSource[0].beforeChange, newValue: realIndex, changeType: .MoveTile)])
                    oldChangeset.removeChange(existingSource[0])
                }
                
                oldChangeset.addChanges([Change(oldValue: realIndex, newValue: realIndex, changeType: .MergeTiles)])
            }
        }
        
        return (out, oldChangeset)
    }
    
    func update(index: Int, direction: Direction) -> Changeset {
        var sequence = self[index, direction]
        var previousSequence = sequence
        var changeset: Changeset
        previousSequence.unshare()
        (sequence, changeset) = compact(sequence, row: index, direction: direction)
        (sequence, changeset) = merge(sequence, row: index, direction: direction, changeset: changeset)
        
        for i in 0..sequence.count {
            tiles[Matrix.realIndex(i, direction: direction, row: index, size: size)] = sequence[i]
        }
        
        return changeset
    }
    
    func noSpaceLeft() -> Bool {
        return countElements(tiles.filter({ (element: Int) in
            element == 0
        })) == 0
    }
    
    func addTile(value: Int) -> Changeset? {
        if noSpaceLeft() {
            return nil //Hai perso
        }
        
        var tileIndex = -1
        do {
            var value = arc4random_uniform((UInt32)(size) * (UInt32)(size))
            tileIndex = Int(value)
        } while tiles[tileIndex] != 0
        
        tiles[tileIndex] = value
        
        for row in 0..size {
            println(self[row, .Right])
        }
        
        return Changeset(newTile: tileIndex)
    }
}

class GameEngine: NSObject {
    let delegate: EngineProtocol
    let matrix: Matrix
    let matrixSize = 4 //This is the only var you need to change if you want a smaller/bigger board

    var bestScore = 0
    var currentScore = 0
    
    init(delegate: EngineProtocol) {
        self.delegate = delegate
        matrix = Matrix(size: matrixSize)
    }
    
    func startGame() {
        readBestScore()
        var changeset: Changeset = Changeset()
        
        changeset.addChanges(matrix.addTile(2)!.changes)
        changeset.addChanges(matrix.addTile(2)!.changes)
        
        delegate.updateTiles(changeset)
    }
    
    func manageCommand(direction: Direction) -> Bool {
        var changeset: Changeset = Changeset()
        for i in 0..matrixSize {
            let updateChangeset = matrix.update(i, direction: direction)
            changeset.addChanges(updateChangeset.changes)
        }
        
        
        if countElements(changeset.changes) == 0 {
            return !matrix.noSpaceLeft()
        }
        
        for change in changeset.changes {
            if change.type == ChangeType.MergeTiles {
                updateScores(matrix.tiles[change.afterChange])
            }
        }
        
        if let newChangeset = matrix.addTile((Int(arc4random() % 2) + 1) * 2) {
            changeset.addChanges(newChangeset.changes)
            
            delegate.updateTiles(changeset)
            return true
        } else {
            return false
        }
    }
    
    func updateScores(score: Int) {
        currentScore += score
        
        if (currentScore > bestScore) {
            bestScore = currentScore
            
            persistBestScore()
        }
        
        delegate.updateCurrentScore(currentScore)
    }
    
    func readBestScore() {
        var defaults = NSUserDefaults(suiteName: "2048")
        bestScore = defaults .integerForKey("2048bestScore")
        
        delegate.updateBestScore(bestScore)
    }
    
    func persistBestScore() {
        var defaults = NSUserDefaults(suiteName: "2048")
        defaults .setInteger(bestScore, forKey: "2048bestScore")
        defaults .synchronize()
        
        delegate.updateBestScore(bestScore)
    }
}