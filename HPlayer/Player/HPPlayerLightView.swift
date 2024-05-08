//
//  HPPlayerLightView.swift
//  HPPlixor
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPPlayerLightView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    class func view() -> HPPlayerLightView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerLightView.self), owner: nil)?.first as! HPPlayerLightView
        view.frame = CGRect(x: 0, y: 0, width: 204, height: 40)
        return view
    }
    
}
