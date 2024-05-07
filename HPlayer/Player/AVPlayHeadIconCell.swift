//
//  AVPlayHeadIconCell.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import UIKit

class AVPlayHeadIconCell: UICollectionViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    var model: AVCastsModel = AVCastsModel() {
        didSet {
            self.iconView.setImage(with: model.cover)
            self.nameL.text = model.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
