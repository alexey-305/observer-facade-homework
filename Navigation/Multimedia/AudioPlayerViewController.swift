import UIKit

class AudioPlayerViewController: UIViewController {
    
    // MARK: - Properties
    private let audioService = AudioPlayerService()
    private var currentTrackIndex = 0
    
    private let trackNames = [
        "Depeche Mode - Behind The Wheel",
        "Depeche Mode - Dangerous",
        "Depeche Mode - It's No Good",
        "Depeche Mode - Little 15",
        "Depeche Mode - Walking in My Shoes"
    ]
    
    private let trackFiles = [
        "Depeche Mode-Behind The Wheel",
        "Depeche Mode-Dangerous",
        "Depeche Mode-Its No Good",
        "Depeche Mode-Little 15",
        "Depeche Mode-Walking in My Shoes"
    ]
    
    // MARK: - UI Elements
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите трек"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⏹️ Stop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⏮️ Предыдущий", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Следующий ⏭️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Готов к воспроизведению"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Аудиоплеер"
        
        audioService.delegate = self
        
        setupUI()
        setupActions()
        loadTrack(index: currentTrackIndex)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(trackNameLabel)
        view.addSubview(playPauseButton)
        view.addSubview(stopButton)
        view.addSubview(buttonsStackView)
        view.addSubview(progressSlider)
        view.addSubview(statusLabel)
        
        buttonsStackView.addArrangedSubview(previousButton)
        buttonsStackView.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            playPauseButton.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 50),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 150),
            playPauseButton.heightAnchor.constraint(equalToConstant: 60),
            
            stopButton.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 20),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonsStackView.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            progressSlider.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressSlider.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func loadTrack(index: Int) {
        guard index >= 0 && index < trackFiles.count else { return }
        currentTrackIndex = index
        trackNameLabel.text = trackNames[currentTrackIndex]
        
        let wasPlaying = audioService.isPlaying
        
        let success = audioService.loadTrack(named: trackFiles[currentTrackIndex], withExtension: "mp3")
        
        if success {
            statusLabel.text = "✅ Загружен: \(trackNames[currentTrackIndex])"
            progressSlider.value = 0
            
            // Если предыдущий трек играл, продолжаем воспроизведение
            if wasPlaying {
                audioService.play()
                playPauseButton.setTitle("⏸️ Pause", for: .normal)
                statusLabel.text = "Воспроизведение"
            } else {
                playPauseButton.setTitle("▶️ Play", for: .normal)
                statusLabel.text = "Готов к воспроизведению"
            }
        } else {
            statusLabel.text = "❌ Ошибка загрузки"
        }
    }
    
    // MARK: - Actions
    @objc private func playPauseTapped() {
        if audioService.isPlaying {
            audioService.pause()
            playPauseButton.setTitle("▶️ Play", for: .normal)
            statusLabel.text = "Пауза"
        } else {
            audioService.play()
            playPauseButton.setTitle("⏸️ Pause", for: .normal)
            statusLabel.text = "Воспроизведение"
        }
    }
    
    @objc private func stopTapped() {
        audioService.stop()
        playPauseButton.setTitle("▶️ Play", for: .normal)
        statusLabel.text = "Остановлено"
        progressSlider.value = 0
    }
    
    @objc private func previousTapped() {
        let newIndex = currentTrackIndex - 1
        if newIndex >= 0 {
            loadTrack(index: newIndex)
        } else {
            statusLabel.text = "Это первый трек"
        }
    }
    
    @objc private func nextTapped() {
        let newIndex = currentTrackIndex + 1
        if newIndex < trackFiles.count {
            loadTrack(index: newIndex)
        } else {
            statusLabel.text = "Это последний трек"
        }
    }
    
    @objc private func sliderValueChanged() {
        audioService.setProgress(progressSlider.value)
    }
}

// MARK: - AudioPlayerServiceDelegate
extension AudioPlayerViewController: AudioPlayerServiceDelegate {
    func audioPlayerDidFinishPlaying() {
        playPauseButton.setTitle("▶️ Play", for: .normal)
        statusLabel.text = "Воспроизведение завершено"
        progressSlider.value = 0
    }
    
    func audioPlayerDidUpdateProgress(currentTime: TimeInterval, duration: TimeInterval) {
        progressSlider.value = audioService.progress
    }
}
