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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
}
