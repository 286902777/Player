//
//  StartViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/11.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var progView: UIProgressView!
    
    var timer: Timer?
    var timeCount: Int = HPADManager.share.maxStartWait
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimer()
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(recordTime), userInfo: nil, repeats: true)
        if let t = timer {
            RunLoop.main.add(t, forMode: .common)
        }
    }
    
    @objc func recordTime() {
        timeCount -= 1
        let p: Float = 1 / Float(HPADManager.share.maxStartWait)
        self.progView.progress += p
        if timeCount <= 0 {
            cancelTimer()
            setRootVC()
        }
    }
    

    func cancelTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func setRootVC() {
        let tabbar = WTabController()
        HPConfig.share.currentWindow()?.rootViewController = tabbar
    }
}
