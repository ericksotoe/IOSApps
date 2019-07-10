//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation // taps into av compoenent of pohone


class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    var selectedSoundFileName : String = ""
    // creates array that holds the filename of the note sounds
    let soundArray = ["note1", "note2", "note3", "note4", "note5", "note6", "note7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func notePressed(_ sender: UIButton) {
        // grabs the correct filename extension depending on tag of button
        selectedSoundFileName = soundArray[sender.tag - 1]
        playSound()
    }
    
    func playSound() {
        // setes up the location of where the sound is
        let soundUrl = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")
        
        do {
            try audioPlayer =  AVAudioPlayer(contentsOf: soundUrl!)
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    
    
}

