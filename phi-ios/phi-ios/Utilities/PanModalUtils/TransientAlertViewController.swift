//
//  TransientAlertViewController.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/19.
//
import UIKit

class TransientAlertViewController: AlertViewController {

    private weak var timer: Timer?
    private var countdown: Int = 1
    private var alertTitle: String

    // 自定義初始化，傳入標題
    init(alertTitle: String) {
        self.alertTitle = alertTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    // 如果使用了Storyboard，必須實現該方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.titleLabel.text = alertTitle
        updateMessage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.countdown -= 1
            self?.updateMessage()
        }
    }

    @objc func updateMessage() {
        guard countdown > 0 else {
            invalidateTimer()
            dismiss(animated: true, completion: nil)
            return
        }
        alertView.message.text = "Message disppears in \(countdown) seconds"
    }

    func invalidateTimer() {
        timer?.invalidate()
    }

    deinit {
        invalidateTimer()
    }

    // MARK: - Pan Modal Presentable

    override var showDragIndicator: Bool {
        return false
    }

    override var anchorModalToLongForm: Bool {
        return true
    }

    override var panModalBackgroundColor: UIColor {
        return .clear
    }

    override var isUserInteractionEnabled: Bool {
        return false
    }
}
