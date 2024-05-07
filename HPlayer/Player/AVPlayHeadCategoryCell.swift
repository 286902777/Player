//
//  AVPlayHeadCategoryCell.swift
//  HPlayer
//
//  Created by HF on 2024/3/3.
//

import UIKit

class AVPlayHeadCategoryCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    
    var model: AVHistoryModel = AVHistoryModel() {
        didSet {
            self.setHistoryData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    func setHistoryData() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
        self.nameL.font = .font(size: 14)
        nameL.text = self.model.text
    }
}
