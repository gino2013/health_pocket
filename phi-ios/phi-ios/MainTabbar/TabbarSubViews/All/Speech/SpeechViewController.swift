//
//  SpeechViewController.swift
//  BleDemo2024
//
//  Created by Kenneth Wu on 2024/12/10.
//

import UIKit
import AVFoundation
import Speech

class SpeechViewController: UIViewController {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1) // 淺灰底色
        textView.textColor = .black
        textView.layer.cornerRadius = 10
        textView.text = "請按下按鈕以開始"
        return textView
    }()
    
    private let speakButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("朗讀文字", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return button
    }()
    
    private let microphoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.setImage(UIImage(systemName: "stop.circle.fill"), for: .selected)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let synthesizer = AVSpeechSynthesizer()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var textToSpeak: String = "你好！這是一個示範繁體中文朗讀的範例。希望你會喜歡。請記得，今天晚上六點半你有設定一個用藥提醒，記得要吃3顆胃藥。"
    private var recognizedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupSpeechRecognition()
        
        speakButton.addTarget(self, action: #selector(didTapSpeakButton), for: .touchUpInside)
        microphoneButton.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(textView)
        view.addSubview(speakButton)
        view.addSubview(microphoneButton)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        speakButton.translatesAutoresizingMaskIntoConstraints = false
        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // TextView 放在視圖頂部，展示文字
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            // Speak 按鈕
            speakButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            speakButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            speakButton.heightAnchor.constraint(equalToConstant: 50),
            speakButton.widthAnchor.constraint(equalToConstant: 120),
            
            // Microphone 按鈕
            microphoneButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            microphoneButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            microphoneButton.heightAnchor.constraint(equalToConstant: 50),
            microphoneButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupSpeechRecognition() {
        // 檢查語音識別器是否可用
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW")) else {
            print("語音識別不可用")
            return
        }
        
        // 明確請求授權
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("語音識別已授權")
            case .denied:
                print("使用者拒絕授權")
            case .restricted:
                print("語音識別被限制")
            case .notDetermined:
                print("尚未決定授權")
            @unknown default:
                break
            }
        }
    }
    
    @objc private func didTapSpeakButton() {
        guard !textToSpeak.isEmpty else {
            print("沒有可朗讀的文字")
            return
        }
        
        // 在文字框顯示 `textToSpeak`
        textView.text = textToSpeak
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        utterance.rate = 0.5
        utterance.volume = 1.0
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            synthesizer.speak(utterance)
        } catch {
            print("音訊會話設置失敗: \(error)")
        }
    }
    
    @objc private func didTapMicrophoneButton() {
        if microphoneButton.isSelected {
            stopRecording()
        } else {
            startRecording()
            microphoneButton.isSelected = true
            textView.text = "辨識中..." // 顯示辨識中狀態
            recognizedText = ""
        }
    }
    
    private func startRecording() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            let inputNode = audioEngine.inputNode
            guard let recognitionRequest = recognitionRequest else {
                fatalError("無法建立語音辨識請求")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                    self.textView.text = self.recognizedText // 實時更新文字
                }
                
                if error != nil || result?.isFinal == true {
                    self.stopRecording()
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0) // 防止重複安裝 Tap
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("錄音設置失敗: \(error)")
            stopRecording() // 確保資源釋放
        }
    }
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.microphoneButton.isSelected = false
            self.textView.text = self.recognizedText.isEmpty ? "未識別到任何文字" : self.recognizedText
        }
    }
}
