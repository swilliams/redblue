//
//  ViewController.swift
//  RedBlue
//
//  Created by Scott Williams on 12/30/17.
//  Copyright © 2017 Scott Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var minutesToPlay = 5
    let peerConnectionService = GameCommunicationManager()
    
    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        minutesToPlay += 1
        updateLabel()
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if (minutesToPlay > 0) {
            minutesToPlay -= 1
        }
        updateLabel()
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {
    }
    
    private func updateLabel() {
        minutesLabel.text = "\(minutesToPlay)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            if let destVC = segue.destination as? GameViewController {
                let gameState = GameState(totalSecondsRemaining: minutesToPlay * 60)
//                let gameState = GameState(totalSecondsRemaining: 5)
                destVC.gameState = gameState
                peerConnectionService.sendGameMessage(message: .Start)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        peerConnectionService.delegate = self
    }
    
    @IBOutlet weak var statusLabel: UILabel!
}

extension ViewController: GameCommunicationManagerDelegate {
    func connectedDevicesChanged(manager: GameCommunicationManager, connectedDevices: [String]) {
        print("devices changed")
    }
    
    func messageSent(manager: GameCommunicationManager, message: GameMessage) {
        print("received message \(message.rawValue)")
        OperationQueue.main.addOperation {
            self.statusLabel.text = message.rawValue
        }
    }
}

