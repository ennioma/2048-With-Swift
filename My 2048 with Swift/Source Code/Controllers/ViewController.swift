//
//  ViewController.swift
//  My 2048 with Swift
//
//  Created by Ennio Masi on 05/06/14.
//  Copyright (c) 2014 enniomasi. All rights reserved.
//

/*
 *
 */

import UIKit

class ViewController: UIViewController, EngineProtocol, UIAlertViewDelegate {

    // Top menu
    @IBOutlet var bestScoreView : ScoreView
    @IBOutlet var currentScoreView : ScoreView
    
    @IBOutlet var boardView : BoardView
    
    var engine: GameEngine?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGesturesOnBoard()
        
        startNewGame()
    }
    
    func startNewGame() {
        engine = GameEngine(delegate: self)
        let e = engine!
        
        boardView.matrix = e.matrix
        e.startGame()
    }
    
    // EngineProtocol methods
    func updateTiles(changeset: Changeset) {
        self.boardView.update(changeset)
    }
    
    func updateBestScore(score: Int) {
        self.bestScoreView.scoreLbl.text = String(score)
    }
    
    func updateCurrentScore(score: Int) {
        self.currentScoreView.scoreLbl.text = String(score)
    }

    // Main View Actions
    @IBAction func openMenu(sender : AnyObject) {
    }
    
    @IBAction func openSettings(sender : AnyObject) {
    }
    
    // Swipe gesture actions
    func setupGesturesOnBoard() {
        let topSwipe = UISwipeGestureRecognizer(target:self, action: Selector("goToTop"))
        topSwipe.direction = UISwipeGestureRecognizerDirection.Up
        topSwipe.numberOfTouchesRequired = 1
        boardView.addGestureRecognizer(topSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target:self, action: Selector("goToRight"))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        rightSwipe.numberOfTouchesRequired = 1
        boardView.addGestureRecognizer(rightSwipe)
        
        let bottomSwipe = UISwipeGestureRecognizer(target:self, action: Selector("goToBottom"))
        bottomSwipe.direction = UISwipeGestureRecognizerDirection.Down
        bottomSwipe.numberOfTouchesRequired = 1
        boardView.addGestureRecognizer(bottomSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target:self, action: Selector("goToLeft"))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        leftSwipe.numberOfTouchesRequired = 1
        boardView.addGestureRecognizer(leftSwipe)
    }
    
    func goToTop() {
        let e = engine!
        if !e.manageCommand(Direction.Up) {
            gameOver()
        }
    }
    
    func goToRight() {
        let e = engine!
        if !e.manageCommand(Direction.Right) {
            gameOver()
        }
    }
    
    func goToBottom() {
        let e = engine!
        if !e.manageCommand(Direction.Down) {
            gameOver()
        }
    }
    
    func goToLeft() {
        let e = engine!
        if !e.manageCommand(Direction.Left) {
            gameOver()
        }
    }
    
    func gameOver() {
        var alert = UIAlertView()
        alert.title = "Game over"
        alert.message = "Your score is \(currentScoreView.scoreLbl.text). Try again!"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        //Restart
        startNewGame()
    }
}

