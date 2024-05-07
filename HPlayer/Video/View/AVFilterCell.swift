//
//  AVFilterCell.swift
//  HPlayer
//
//  Created by HF on 2024/3/27.
//

import UIKit

class AVFilterCell: UICollectionViewCell {

    @IBOutlet weak var titleL: UILabel!
    var model: AVFilterCategoryInfoModel = AVFilterCategoryInfoModel() {
        didSet {
            self.setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleL.layer.masksToBounds = true
    }

    func setData() {
        if self.model.isSelect {
            self.titleL.layer.cornerRadius = 16
            self.titleL.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            self.titleL.backgroundColor = UIColor.hexColor("#5548C1", alpha: 0.5)
        } else {
            self.titleL.layer.cornerRadius = 0
            self.titleL.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            self.titleL.backgroundColor = .clear
        }
        self.titleL.text = self.model.title
    }
}
