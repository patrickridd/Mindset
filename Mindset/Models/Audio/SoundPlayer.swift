import AVFoundation
import AudioToolbox

class SoundPlayer {
    private var audioPlayer: AVAudioPlayer?

    func playSound(named name: SoundEffect) {
        guard let url = Bundle.main.url(forResource: name.rawValue,
                                        withExtension: "mp3")
        else {
            return
        }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }

    // Existing system sound methods
    func stepComplete() {
        let systemSoundID: SystemSoundID = 1113
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playEntryComplete() {
        let systemSoundID: SystemSoundID = 1407
        AudioServicesPlaySystemSound(systemSoundID)
    }

    func entryStarted() {
        // Optionally play a custom mp3, or keep system sound
        let systemSoundID: SystemSoundID = 1013
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
