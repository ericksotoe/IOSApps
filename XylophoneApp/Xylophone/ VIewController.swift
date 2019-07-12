
import UIKit
import AVFoundation // taps into av compoenent of pohone


class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    // creates array that holds the filename of the note sounds
    let soundArray = ["note1", "note2", "note3", "note4", "note5", "note6", "note7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func notePressed(_ sender: UIButton) {
        playSound(soundFileName: soundArray[sender.tag - 1])
    }
    
    func playSound(soundFileName: String) {
        // setes up the location of where the sound is
        let soundUrl = Bundle.main.url(forResource: soundFileName, withExtension: "wav")
        
        do {
            try audioPlayer =  AVAudioPlayer(contentsOf: soundUrl!)
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    
    
}

