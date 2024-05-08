//
//  AVSearchItemCell.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVSearchItemCell: UICollectionViewCell {
    @IBOutlet weak var topImgV: UIImageView!
    
    @IBOutlet weak var topL: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var contentL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.cornerRadius = 4
        imageV.layer.masksToBounds = true
    }

    func setModel(model: AVDataInfoModel, _ index: Int) {
        self.topL.text = "\(index + 1)"
        self.contentL.text = model.title
        self.imageV.setImage(with: model.cover)
        switch index {
        case 0:
            self.topImgV.image = UIImage(named: "play_top_1")
        case 1:
            self.topImgV.image = UIImage(named: "play_top_2")
        case 2:
            self.topImgV.image = UIImage(named: "play_top_3")
        default:
            self.topImgV.image = UIImage(named: "play_top_4")
        }
    }
}
