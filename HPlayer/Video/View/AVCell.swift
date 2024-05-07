//
//  AVCell.swift
//  HPlayer
//
//  Created by HF on 2024/3/3.
//

import UIKit

class AVCell: UICollectionViewCell {
    @IBOutlet weak var epsL: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var contentL: UILabel!
    
    @IBOutlet weak var progressV: UIProgressView!
    @IBOutlet weak var scoreL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.cornerRadius = 4
        imageV.layer.masksToBounds = true
    }

    func setScoreFont(_ text: String) {
        let shadow = NSShadow()
        // 设置阴影的颜色
        shadow.shadowColor = UIColor.hexColor("#000000", alpha: 0.1)
        // 设置阴影的偏移量
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        // 设置阴影的模糊半径
        shadow.shadowBlurRadius = 3
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Bebas Neue Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.hexColor("#796BFF"),  .strokeColor: UIColor.hexColor("#796BFF"), .strokeWidth: -4, .shadow: shadow]
        scoreL.attributedText = NSAttributedString(string: text, attributes: attr)
    }
  
    func setModel(model: AVDataInfoModel, _ isHistory: Bool = false) {
        if isHistory, model.type == 2 {
            self.epsL.isHidden = false
            self.epsL.text = model.ssn_eps
        } else {
            self.epsL.isHidden = true
        }
        self.progressV.isHidden = !isHistory
        self.progressV.progress = Float(model.playProgress)
        if let r = Float(model.rate) {
            self.scoreL.isHidden = false
            self.setScoreFont(String(format: "%.1f", r))
        } else {
            self.scoreL.isHidden = true
        }
        self.contentL.text = model.title
        self.imageV.setImage(with: model.cover)
    }
}
