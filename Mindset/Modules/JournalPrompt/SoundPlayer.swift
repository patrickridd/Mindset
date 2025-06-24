import AudioToolbox

struct SoundPlayer {
    func stepComplete() {
        let systemSoundID: SystemSoundID = 1113
        AudioServicesPlaySystemSound(systemSoundID)
    }

    func playEntryComplete() {
        let systemSoundID: SystemSoundID = 1013
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
