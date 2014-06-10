//
//  ScoreView.swift
//  My 2048 with Swift
//
//  Created by Ennio Masi on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

import UIKit

class ScoreView: BaseView {
    @IBOutlet var scoreLbl : UILabel
    @IBOutlet var titleLbl : UILabel
 
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
    }
    
    func setScore(score: Int) {
        scoreLbl.text = String(score)
    }
    
    func setScoreWithAnimation(score: Int) {
        setScore(score)
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeCubicPaced, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: {
                self.scoreLbl.transform = CGAffineTransformMakeScale(1.4, 1.4);
                })
            
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.2, animations: {
                self.scoreLbl.transform = CGAffineTransformIdentity;
                })
            }, completion: nil)
    }
}
