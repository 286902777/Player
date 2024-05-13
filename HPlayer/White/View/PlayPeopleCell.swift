//
//  PlayPeopleCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlayPeopleCell: UICollectionViewCell {

    @IBOutlet weak var iconV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.iconV.layer.cornerRadius = 44
        self.iconV.layer.masksToBounds = true
    }
    
    func setModel(_ model: IndexDataListModel) {
        self.iconV.setImage(with: model.cover)
        self.nameL.text = model.name
    }
}
