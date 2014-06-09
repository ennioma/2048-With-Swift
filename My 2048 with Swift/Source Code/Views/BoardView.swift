//
//  BoardView.swift
//  My 2048 with Swift
//
//  Created by Ennio Masi on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import UIKit

class BoardView: BaseView {
    var boardSize: Int
    var tiles: Tile?[]
    var originalTileFrames: CGRect[]
    
    init(coder aDecoder: NSCoder!) {
        boardSize = 0
        tiles = Tile[]()
        originalTileFrames = CGRect[]()
        
        super.init(coder: aDecoder)
    }
    
    var matrix: Matrix? = nil {
        didSet {
            if let notNilMatrix = matrix {
                boardSize = notNilMatrix.size
                tiles = Tile[]()
                originalTileFrames = CGRect[]()
                
                for idx in 0..boardSize*boardSize {
                    tiles.insert(nil, atIndex: idx)
                    originalTileFrames.insert(CGRect.zeroRect, atIndex: idx)
                }
                
                createBoard(boardSize)
            }
        }
    }
    
    func createBoard(size: Int) {
        let padding: Float = 8
        var y = padding
        let availableSpace: Float = self.frame.width - (Float)(size + 1)*padding
        let tileSize: Float = availableSpace / (Float)(size)
        
        for subview: AnyObject in self.subviews {
            let castedSubview: UIView = subview as UIView
            castedSubview.removeFromSuperview()
        }
        
        for a in 0..size {
            var x = padding
            for b in 0..size {
                var tile = Tile(position: CGPoint(x: x, y: y), insideValue: 0, size: tileSize)
                tile.layer.zPosition = 2
                
                var backgroundTile = UIView(frame:  tile.frame)
                backgroundTile.backgroundColor = tile.backgroundColor
                addSubview(backgroundTile)
                originalTileFrames[a*size + b] = backgroundTile.frame
                
                addSubview(tile)
                tiles[a*size + b] = tile
                
                x += tileSize + padding
            }
            
            y += tileSize + padding
        }
    }
    
    func updateTiles() {
        for a in 0..boardSize {
            for b in 0..boardSize {
                let value = matrix!.tiles[a*boardSize + b]
                var tile = tiles[a*boardSize + b]
                tile!.tileValue = value
            }
        }
    }

    func update(changeset: Changeset) {
        println("changeset: \(changeset)")
        
        //Perform the animations, and then update the model behind
        UIView.animateWithDuration(0.2, animations: {
            for change: Change in changeset.changes {
                switch change.type {
                    case .MoveTile:
                        var tileToMove = self.tiles[change.beforeChange]!
                        tileToMove.layer.zPosition = 10
                        var frameToResemble = self.originalTileFrames[change.afterChange]
                        tileToMove.frame = frameToResemble
                    case .MergeTiles, .NewTile:
                        break
                }
            }
        }, completion: { (_: Bool) in
            self.updateTiles()
            
            for change: Change in changeset.changes {
                switch change.type {
                    case .NewTile:
                        let tile: Tile? = self.tiles[change.afterChange]
                        tile!.transform = CGAffineTransformMakeScale(0.4, 0.4)
                        UIView.animateWithDuration(0.2, animations: {
                            tile!.transform = CGAffineTransformIdentity;
                        })
                    case .MergeTiles:
                        let tile: Tile? = self.tiles[change.afterChange]
                    
                        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeCubicPaced, animations: {
                            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: {
                                tile!.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            })
                            
                            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.2, animations: {
                                tile!.transform = CGAffineTransformIdentity;
                            })
                            }, completion: nil)
                    case .MoveTile:
                        //If move tile, move frame
                        var tileToMove = self.tiles[change.beforeChange]!
                        tileToMove.frame = self.originalTileFrames[change.beforeChange]
                        tileToMove.layer.zPosition = 2
                }
            }
        })
    }
}