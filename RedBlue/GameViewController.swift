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

class GameViewController: UIViewController {
    @IBOutlet weak var leftSideButton: UIButton!
    @IBOutlet weak var rightSideButton: UIButton!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var rightTimeLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    
    var totalSecondsRemaining: Int = 10
    var leftSecondsTotal: Int = 0
    var rightSecondsTotal: Int = 0
    
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
    
    private func tick() {
        if (totalSecondsRemaining <= 0) {
            end()
            return
        }
        totalSecondsRemaining -= 1
        if (self.activeSide == .Left) {
            leftSecondsTotal += 1
        } else if (self.activeSide == .Right) {
            rightSecondsTotal += 1
        }
        updateUI()
    }
    
    private func buildTimeTextForSeconds(numberOfSeconds: Int) -> String {
        let minutesRemaining: Int = numberOfSeconds / 60
        let secondsRemaining = numberOfSeconds % 60
        let secondsTextRemaining = secondsRemaining < 10 ? "0\(secondsRemaining)" : "\(secondsRemaining)"
        return "\(minutesRemaining):\(secondsTextRemaining)"
    }
    
    private func updateUI() {
        mainTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: totalSecondsRemaining)
        leftTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: leftSecondsTotal)
        rightTimeLabel.text = buildTimeTextForSeconds(numberOfSeconds: rightSecondsTotal)
    }
    
    private func end() {
        timer.invalidate()
        effectsPlayer.playSoundEffect(effect: .GameOver)
        performSegue(withIdentifier: "endSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endSegue" {
            if let destVC = segue.destination as? EndViewController {
                if leftSecondsTotal > rightSecondsTotal {
                    destVC.winText = "Red Wins"
                } else if (leftSecondsTotal == rightSecondsTotal) {
                    destVC.winText = "Tie"
                } else {
                    destVC.winText = "Blue Wins"
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activeSide = .None
        leftSecondsTotal = 0
        rightSecondsTotal = 0
        leftSideButton.backgroundColor = UIColor.red
        rightSideButton.backgroundColor = UIColor.blue
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.tick()
        })
        effectsPlayer.playSoundEffect(effect: .Start)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
