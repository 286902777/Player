//
//  AVHistoryCell.swift
//  HPlayer
//
//  Created by HF on 2024/1/10.
//

import UIKit

class AVHistoryCell: UITableViewCell {
    @IBOutlet weak var leftW: NSLayoutConstraint!
    
    @IBOutlet weak var epsL: UILabel!
    
    @IBOutlet weak var coverImgV: UIImageView!
    
    @IBOutlet weak var selectImgV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var scoreL: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scoreL.font = UIFont(name: "Bebas Neue Regular", size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(isShow: Bool, model: AVDataInfoModel) {
        self.epsL.isHidden = model.type == 1
        self.epsL.text = model.ssn_eps
        self.selectImgV.isHidden = !isShow
        self.leftW.constant = isShow ? 44 : 0
        self.coverImgV.setImage(with: model.cover)
        self.progressView.progress = Float(model.playProgress)
        if let r = Float(model.rate) {
            self.scoreL.isHidden = false
            self.scoreL.text = String(format: "%.1f", r)
        } else {
            self.scoreL.isHidden = true
        }
        self.nameL.text = model.title
        self.selectImgV.image = UIImage(named: model.isSelect ? "his_select" : "his_unSelect")
    }
    
}
