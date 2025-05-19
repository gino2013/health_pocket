//
//  LottieUtils.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/9/5.
//

import UIKit
import Lottie

/// `LottieUtils` 類別包含了一組Lottie的工具函式。
class LottieUtils {
    
    // 設置並播放進度條動畫
    static func setupProgressBar(in view: UIView, animationName: String, startProgress: CGFloat, endProgress: CGFloat, completion: (() -> Void)? = nil) -> LottieAnimationView {
        let progressBarAnimationView = LottieAnimationView(name: animationName)
        progressBarAnimationView.contentMode = .scaleAspectFit
        
        // 確保動畫視圖使用 Auto Layout
        progressBarAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressBarAnimationView)
        
        // 設置動畫的居中約束
        NSLayoutConstraint.activate([
            progressBarAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBarAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBarAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            progressBarAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        // 播放進度條動畫
        progressBarAnimationView.play(fromProgress: startProgress, toProgress: endProgress, loopMode: .none) { finished in
            completion?() // 執行完成回調
        }
        return progressBarAnimationView
    }
    
    // 設置並無限循環播放動畫
    static func setupLoopingAnimation(in view: UIView, animationName: String) -> LottieAnimationView {
        let loopingAnimationView = LottieAnimationView(name: animationName)
        loopingAnimationView.contentMode = .scaleAspectFit
        
        // 確保動畫視圖使用 Auto Layout
        loopingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loopingAnimationView)
        
        // 設置動畫的居中約束
        NSLayoutConstraint.activate([
            loopingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loopingAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loopingAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            loopingAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        // 設置無限循環播放
        loopingAnimationView.loopMode = .loop
        loopingAnimationView.play()
        
        return loopingAnimationView
    }
    
    // 更新進度條動畫
    static func updateProgressBar(animationView: LottieAnimationView, fromProgress: CGFloat, toProgress: CGFloat, completion: (() -> Void)? = nil) {
        animationView.play(fromProgress: fromProgress, toProgress: toProgress, loopMode: .none) { finished in
            completion?() // 執行完成回調
        }
    }
}
