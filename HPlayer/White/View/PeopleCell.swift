//
//  PeopleCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PeopleCell: UICollectionViewCell {

    @IBOutlet weak var iconV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        let r = (floor((kScreenWidth - 48) / 3) - 22) * 0.5
        self.iconV.layer.cornerRadius = r
        self.iconV.layer.masksToBounds = true
    }
    
    func setModel(model: IndexDataListModel) {
        self.iconV.setImage(with: model.cover)
        self.nameL.text = model.name
    }
}
