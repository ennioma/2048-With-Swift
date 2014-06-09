//
//  Tile.swift
//  My 2048 with Swift
//
//  Created by Vittorio Monaco on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import Foundation
import UIKit

struct TileColor {
    static var colors: Dictionary<Int, UIColor> {
        return [
            0 : UIColor(red: 250/255, green: 245/255, blue: 237/255, alpha: 1.0),
            2 : UIColor(red: 234/255, green: 222/255, blue: 209/255, alpha: 1.0),
            4 : UIColor(red: 231/255, green: 218/255, blue: 187/255, alpha: 1.0),
            8 : UIColor(red: 238/255, green: 160/255, blue: 96/255, alpha: 1.0),
            16 : UIColor(red: 200/255, green: 110/255, blue: 57/255, alpha: 1.0),
            32 : UIColor(red: 240/255, green: 103/255, blue: 76/255, alpha: 1.0),
            64 : UIColor(red: 228/255, green: 65/255, blue: 35/255, alpha: 1.0),
            128 : UIColor(red: 240/255, green: 210/255, blue: 80/255, alpha: 1.0),
            256 : UIColor(red: 63/255, green: 180/255, blue: 100/255, alpha: 1.0),
            512 : UIColor(red: 200/255, green: 170/255, blue: 15/255, alpha: 1.0),
            1024 : UIColor(red: 200/255, green: 155/255, blue: 0/255, alpha: 1.0)
        ]
    }
    
    static let defaultColor: UIColor = UIColor.purpleColor()
}

class Tile : UIView {
    let tileLabel: UILabel
    let tileSize: Float
    
    var tileValue: Int {
        didSet {
            tileLabel.text = String(tileValue)
            tileLabel.hidden = tileValue == 0
            backgroundColor = color()
            tileLabel.textColor = textColor()
        }
    }
    
    init(position: CGPoint, insideValue: Int, size: Float) {
        tileSize = size
        tileLabel = UILabel(frame: CGRectMake(0, 0, tileSize, tileSize))
        tileValue = insideValue
        super.init(frame: CGRectMake(position.x, position.y, tileSize, tileSize))
        backgroundColor = color()
        
        tileLabel.font = UIFont(name: "Helvetica Neue", size: 40)
        tileLabel.textColor = textColor()
        tileLabel.textAlignment = NSTextAlignment.Center
        addSubview(tileLabel)
    }
    
    func color() -> UIColor {
        if let knownColor = TileColor.colors[tileValue] {
            return knownColor
        } else {
            return TileColor.defaultColor
        }
    }
    
    // Refactor the tile color management
    func textColor() -> UIColor {
        if tileValue <= 4 {
            return UIColor(red: 173/255, green: 157/255, blue: 143/255, alpha: 1.0)
        } else {
            return UIColor(red: 250/255, green: 245/255, blue: 237/255, alpha: 1.0)
        }
    }
}
