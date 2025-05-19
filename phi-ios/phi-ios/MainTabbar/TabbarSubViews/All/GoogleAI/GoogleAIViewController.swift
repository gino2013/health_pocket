//
//  GoogleAIViewController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/12/16.
//

import UIKit
import Speech
import AVFoundation

class GoogleAIViewController: UIViewController {
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "輸入提示文字"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.text = "生成結果將顯示於此"
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    private let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("生成文字", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return button
    }()
    
    private let microphoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.setImage(UIImage(systemName: "stop.circle.fill"), for: .selected)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var recognizedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupSpeechRecognition()
        
        generateButton.addTarget(self, action: #selector(didTapGenerateButton), for: .touchUpInside)
        microphoneButton.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(inputTextField)
        view.addSubview(resultTextView)
        view.addSubview(generateButton)
        view.addSubview(microphoneButton)
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        resultTextView.translatesAutoresizingMaskIntoConstraints = false
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 40),
            
            resultTextView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            resultTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultTextView.heightAnchor.constraint(equalToConstant: 300),
            
            generateButton.topAnchor.constraint(equalTo: resultTextView.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            microphoneButton.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20),
            microphoneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            microphoneButton.widthAnchor.constraint(equalToConstant: 60),
            microphoneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupSpeechRecognition() {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW")) else {
            print("語音識別不可用")
            return
        }
        
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
    
    @objc private func didTapMicrophoneButton() {
        if audioEngine.isRunning {
            inputTextField.isEnabled = true
            stopRecording()
        } else {
            // 開始錄音前清空文字
            inputTextField.isEnabled = false
            inputTextField.text = ""
            startRecording()
            microphoneButton.isSelected = true
            resultTextView.text = "辨識中..." // 更新狀態
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
                    // 檢查文字是否有效，避免覆蓋為空字串
                    let recognizedText = result.bestTranscription.formattedString
                    if !recognizedText.isEmpty {
                        self.recognizedText = recognizedText
                        self.inputTextField.text = self.recognizedText
                    }
                }
                
                // 停止辨識任務或出現錯誤時結束錄音
                if error != nil || result?.isFinal == true {
                    self.stopRecording()
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("錄音設置失敗: \(error)")
            stopRecording()
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
            // 停止後保持當前文字內容
            if self.recognizedText.isEmpty {
                self.resultTextView.text = "語音辨識已停止，未識別到任何文字"
            } else {
                self.resultTextView.text = "語音辨識已停止"
            }
        }
    }
    
    @objc private func didTapGenerateButton() {
        guard let prompt = inputTextField.text, !prompt.isEmpty else {
            resultTextView.text = "請輸入提示文字"
            return
        }
        
        resultTextView.text = "生成中..."
        
        let apiKey = "AIzaSyBOgd2DIKyOKtysWESGo3Ppf_xsiPIBIQU"
        let geminiManager = GeminiAPIManager(apiKey: apiKey)
        
        geminiManager.generateContent(prompt: prompt) { result in
            switch result {
            case .success(let text):
                DispatchQueue.main.async {
                    self.resultTextView.text = "\(text)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.resultTextView.text = "出錯：\(error.localizedDescription)"
                }
            }
        }
    }
}
