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
        var changeset = Changeset()
        
        changeset.addChanges(matrix.addTile(2)!.changes)
        changeset.addChanges(matrix.addTile(2)!.changes)
        
        delegate.updateTiles(changeset)
    }
    
    func manageCommand(direction: Direction) -> Bool {
        var changeset = Changeset()
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
        defaults.setInteger(bestScore, forKey: "2048bestScore")
        defaults.synchronize()
    }
}