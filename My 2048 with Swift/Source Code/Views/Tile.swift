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
            2 : UIColor(red: 236/255, green: 226/255, blue: 215/255, alpha: 1.0),
            4 : UIColor(red: 235/255, green: 222/255, blue: 196/255, alpha: 1.0),
            8 : UIColor(red: 239/255, green: 172/255, blue: 113/255, alpha: 1.0),
            16 : UIColor(red: 242/255, green: 142/255, blue: 91/255, alpha: 1.0),
            32 : UIColor(red: 243/255, green: 114/255, blue: 87/255, alpha: 1.0),
            64 : UIColor(red: 242/255, green: 82/255, blue: 52/255, alpha: 1.0),
            128 : UIColor(red: 235/255, green: 205/255, blue: 106/255, alpha: 1.0),
            256 : UIColor(red: 235/255, green: 202/255, blue: 89/255, alpha: 1.0),
            512 : UIColor(red: 235/255, green: 197/255, blue: 73/255, alpha: 1.0),
            1024 : UIColor(red: 233/255, green: 194/255, blue: 56/255, alpha: 1.0),
            2048 : UIColor(red: 239/255, green: 196/255, blue: 8/255, alpha: 1.0),
            4096 : UIColor(red: 239/255, green: 196/255, blue: 56/255, alpha: 1.0)
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
        tileLabel = UILabel(frame: CGRectMake(0, 0, (CGFloat)(tileSize), (CGFloat)(tileSize)))
        tileValue = insideValue
        super.init(frame: CGRectMake(position.x, position.y, (CGFloat)(tileSize), (CGFloat)(tileSize)))
        backgroundColor = color()
        
        tileLabel.font = UIFont(name: "Helvetica Neue", size: 32)
        tileLabel.textColor = textColor()
        tileLabel.textAlignment = NSTextAlignment.Center
        addSubview(tileLabel)
    }

    required init(coder aDecoder: NSCoder) {
        self.tileLabel = UILabel()
        self.tileSize = 10
        self.tileValue = 0
        
        super.init(coder: aDecoder)
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
