//
//  HPRefresh.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import Foundation
import MJRefresh
import Lottie

class RefreshGifHeader: MJRefreshGifHeader{
    override func prepare() {
        super.prepare()
        self.gifView?.isHidden = true
        let lottieV = LottieAnimationView(name: "refresh")
        let v = UIView(frame: CGRect(x: (kScreenWidth - 60) * 0.5, y: 10, width: 60, height: 60))
        lottieV.frame = v.bounds
        lottieV.loopMode = .loop
        lottieV.play()
        v.addSubview(lottieV)
        self.addSubview(v)
        self.mj_h = 80
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
    }
}

class RefreshAutoNormalFooter: MJRefreshAutoStateFooter {
    override func prepare() {
        super.prepare()
        self.mj_h = 65
        self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
        self.stateLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.setTitle("", for: .idle)
        self.setTitle("", for: .refreshing)
        self.setTitle("No more content", for: .noMoreData)
    }
}

class RefreshFilterGifHeader: MJRefreshGifHeader{
    override func prepare() {
        super.prepare()
        self.gifView?.isHidden = true
        let lottieV = LottieAnimationView(name: "refresh")
        let v = UIView(frame: CGRect(x: (kScreenWidth - 60) * 0.5, y: -202, width: 60, height: 60))
        lottieV.frame = v.bounds
        lottieV.loopMode = .loop
        lottieV.play()
        v.addSubview(lottieV)
        self.addSubview(v)
        self.mj_h = 80
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
    }
}

