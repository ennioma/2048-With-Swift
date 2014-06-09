//
//  BaseLabel.swift
//  My 2048 with Swift
//
//  Created by Ennio Masi on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 6
    }
}
