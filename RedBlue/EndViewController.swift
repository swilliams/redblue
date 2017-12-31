//
//  EndViewController.swift
//  RedBlue
//
//  Created by Scott Williams on 12/30/17.
//  Copyright © 2017 Scott Williams. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var redResultsLabel: UILabel!
    @IBOutlet weak var blueResultsLabel: UILabel!
    
    var gameState = GameState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIFromState()
    }
    
    func updateUIFromState() {
        let redTime = buildTimeTextForSeconds(numberOfSeconds: gameState.leftSecondsTotal)
        let blueTime = buildTimeTextForSeconds(numberOfSeconds: gameState.rightSecondsTotal)
        redResultsLabel.text = "Red Time: \(redTime)"
        blueResultsLabel.text = "Blue Time: \(blueTime)"
        
        if gameState.leftSecondsTotal > gameState.rightSecondsTotal {
            winLabel.text = "Red Wins"
            winLabel.textColor = UIColor.red
        } else if (gameState.leftSecondsTotal == gameState.rightSecondsTotal) {
            winLabel.text = "Tie"
            winLabel.textColor = UIColor.black
        } else {
            winLabel.text = "Blue Wins"
            winLabel.textColor = UIColor.blue
        }
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
