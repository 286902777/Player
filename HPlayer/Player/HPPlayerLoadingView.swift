//
//  HPPlayerLoadingView.swift
//  HPPlixor
//
//  Created by HF on 2024/4/21.
//


import UIKit
import Lottie

class HPPlayerLoadingView: UIView {
    
    @IBOutlet weak var lottieView: UIView!
    var gifView: LottieAnimationView?
    
    class func view() -> HPPlayerLoadingView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerLoadingView.self), owner: nil)?.first as! HPPlayerLoadingView
        view.setUpUI()
        return view
    }
    
    func setUpUI() {
        gifView = LottieAnimationView(name: "loading")
        lottieView.addSubview(gifView!)
        gifView?.isHidden = true
        gifView?.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
    }
    
    func show(progress: CGFloat = 0) {
        gifView?.isHidden = false
        gifView?.currentProgress = progress
        gifView?.isHidden = false
        gifView?.play(fromProgress: progress, toProgress: 1 - progress, loopMode: .loop, completion: {(state) in

        })
    }
    
    func dismiss() {
        gifView?.currentProgress = 0
        gifView?.stop()
        gifView?.isHidden = true
    }
}
