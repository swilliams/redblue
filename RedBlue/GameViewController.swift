//
//  GameViewController.swift
//  RedBlue
//
//  Created by Scott Williams on 12/30/17.
//  Copyright © 2017 Scott Williams. All rights reserved.
//

import UIKit

enum ActiveSide {
    case None, Left, Right
}

func buildTimeTextForSeconds(numberOfSeconds: Int) -> String {
    let minutesRemaining: Int = numberOfSeconds / 60
    let secondsRemaining = numberOfSeconds % 60
    let secondsTextRemaining = secondsRemaining < 10 ? "0\(secondsRemaining)" : "\(secondsRemaining)"
    return "\(minutesRemaining):\(secondsTextRemaining)"
}

struct GameState {
    var totalSecondsRemaining: Int
    var leftSecondsTotal: Int = 0
    var rightSecondsTotal: Int = 0
    
    init() {
        self.totalSecondsRemaining = 10
    }
    
    init(totalSecondsRemaining: Int) {
        self.totalSecondsRemaining = totalSecondsRemaining
    }
    
    mutating func reset() {
        leftSecondsTotal = 0
        rightSecondsTotal = 0
    }
}

class GameViewController: UIViewController {
    @IBOutlet weak var leftSideButton: UIButton!
    @IBOutlet weak var rightSideButton: UIButton!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var rightTimeLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    
    var gameState = GameState()
    
    var activeSide: ActiveSide = .None
    
    var timer = Timer()
    
    let effectsPlayer = SoundPlayer()
    
    @IBAction func leftSideTapped(_ sender: Any) {
        if activeSide != .Left {
            effectsPlayer.playSoundEffect(effect: .Red)
        }
        activeSide = .Left
    }
    
    @IBAction func rightSideTapped(_ sender: Any) {
        if activeSide != .Right {
            effectsPlayer.playSoundEffect(effect: .Blue)
        }
        activeSide = .Right
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func tick() {
        if (gameState.totalSecondsRemaining <= 0) {
            end()
            return
        }
        gameState.totalSecondsRemaining -= 1
        if (self.activeSide == .Left) {
            gameState.leftSecondsTotal += 1
        } else if (self.activeSide == .Right) {
            gameState.rightSecondsTotal += 1
        }
        updateUI()
    }
    
    private func updateUI() {
        mainTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: gameState.totalSecondsRemaining)
        leftTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: gameState.leftSecondsTotal)
        rightTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: gameState.rightSecondsTotal)
    }
    
    private func end() {
        timer.invalidate()
        effectsPlayer.playSoundEffect(effect: .GameOver)
        performSegue(withIdentifier: "endSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endSegue" {
            if let destVC = segue.destination as? EndViewController {
                destVC.gameState = gameState
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameState.reset()
        activeSide = .None
        leftSideButton.backgroundColor = UIColor.red
        rightSideButton.backgroundColor = UIColor.blue
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.tick()
        })
        effectsPlayer.playSoundEffect(effect: .Start)
        
    }
}
