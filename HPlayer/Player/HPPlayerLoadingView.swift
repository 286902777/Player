//
//  HPPlayerLoadingView.swift
//  HPPlixor
//
//  Created by HF on 2023/12/21.
//


import UIKit
import Lottie

class HPPlayerLoadingView: UIView {
    
    @IBOutlet weak var lottieView: UIView!
    var animaView: LottieAnimationView?
    
    class func view() -> HPPlayerLoadingView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerLoadingView.self), owner: nil)?.first as! HPPlayerLoadingView
        view.setUpUI()
        return view
    }
    
    func setUpUI() {
        animaView = LottieAnimationView(name: "loading")
        lottieView.addSubview(animaView!)
        animaView?.isHidden = true
        animaView?.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
    }
    
    func show(progress: CGFloat = 0) {
        animaView?.isHidden = false
        animaView?.currentProgress = progress
        animaView?.isHidden = false
        animaView?.play(fromProgress: progress, toProgress: 1 - progress, loopMode: .loop, completion: {(state) in

        })
    }
    
    func dismiss() {
        animaView?.currentProgress = 0
        animaView?.stop()
        animaView?.isHidden = true
    }
}
