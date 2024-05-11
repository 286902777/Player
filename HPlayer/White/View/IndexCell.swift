//
//  IndexCell.swift
//  HPlayer
//
//  Created by HF on 2024/3/3.
//

import UIKit

class IndexCell: UICollectionViewCell {
    @IBOutlet weak var likeView: UIImageView!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var contentL: UILabel!
    
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
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Open Sans Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.hexColor("#B2AAFF"),  .strokeColor: UIColor.hexColor("#B2AAFF"), .strokeWidth: -4, .shadow: shadow]
        scoreL.attributedText = NSAttributedString(string: text, attributes: attr)
    }
  
    func setModel(model: IndexDataListModel) {
        let arr = DBManager.share.selectWhiteData()
        if let m = arr.first(where: {$0.id == model.id}) {
            model.isLike = true
        }
        if let r = Float(model.rate) {
            self.scoreL.isHidden = false
            self.setScoreFont(String(format: "%.1f", r))
        } else {
            self.scoreL.isHidden = true
        }
        self.likeView.image = UIImage(named: model.isLike ? "w_like" : "w_unlike")
        self.contentL.text = model.title
        self.imageV.setImage(with: model.cover)
    }
}
