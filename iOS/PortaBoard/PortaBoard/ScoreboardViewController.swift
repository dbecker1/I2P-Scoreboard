//
//  ScoreboardViewController.swift
//  PortaBoard
//
//  Created by Daniel Becker on 9/6/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController {
    
    private var homeScore: Int! = 0
    private var awayScore: Int! = 0

    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScores()
    }


    @IBAction func increaseHomeScore(_ sender: UIButton) {
        homeScore = min(homeScore + 1, 99)
        updateScores()
    }
    
    @IBAction func decreaseHomeScore(_ sender: UIButton) {
        homeScore = max(homeScore - 1, 0)
        updateScores()
    }
    
    @IBAction func increaseAwayScore(_ sender: UIButton) {
        awayScore = min(awayScore + 1, 99)
        updateScores()
    }
    
    @IBAction func decreaseAwayScore(_ sender: UIButton) {
        awayScore = max(awayScore - 1, 0)
        updateScores()
    }
    
    private func updateScores() {
        let homeScoreString = String(format: "%02d", homeScore)
        let awayScoreString = String(format: "%02d", awayScore)
        
        homeScoreLabel.text = homeScoreString
        awayScoreLabel.text = awayScoreString
    }
    
    }
