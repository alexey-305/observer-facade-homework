import Foundation
import AVFoundation

protocol AudioPlayerServiceDelegate: AnyObject {
    func audioPlayerDidFinishPlaying()
    func audioPlayerDidUpdateProgress(currentTime: TimeInterval, duration: TimeInterval)
}

class AudioPlayerService: NSObject {
    
    // MARK: - Properties
    private var audioPlayer: AVAudioPlayer?
    weak var delegate: AudioPlayerServiceDelegate?
    private(set) var isPlaying = false
    private var progressTimer: Timer?
    
    // MARK: - Public Methods
    func loadTrack(named fileName: String, withExtension ext: String) -> Bool {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("❌ Файл \(fileName).\(ext) не найден")
            return false
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            return true
        } catch {
            print("❌ Ошибка загрузки: \(error)")
            return false
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startProgressTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopProgressTimer()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        stopProgressTimer()
    }
    
    func setProgress(_ value: Float) {
        guard let player = audioPlayer else { return }
        let newTime = Double(value) * player.duration
        player.currentTime = newTime
    }
    
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var currentTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var progress: Float {
        guard let player = audioPlayer, player.duration > 0 else { return 0 }
        return Float(player.currentTime / player.duration)
    }
    
    // MARK: - Private Methods
    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    @objc private func updateProgress() {
        delegate?.audioPlayerDidUpdateProgress(currentTime: currentTime, duration: duration)
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            stopProgressTimer()
            delegate?.audioPlayerDidFinishPlaying()
        }
    }
}
