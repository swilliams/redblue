//
//  AudioPlayer.swift
//  RedBlue
//
//  Created by Scott Williams on 12/30/17.
//  Copyright © 2017 Scott Williams. All rights reserved.
//

import UIKit
import AVFoundation

enum SoundEffect: String {
    case Start = "start",
    Blue = "blue",
    Red = "red",
    GameOver = "game over"
}

class SoundPlayer {
    private var player: AVAudioPlayer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundEffect(effect: SoundEffect) {
        guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
