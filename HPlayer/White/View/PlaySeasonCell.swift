//
//  PlaySeasonCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlaySeasonCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var selectView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        imgV.layer.cornerRadius = 4
        imgV.layer.masksToBounds = true
        bgView.layer.borderColor = UIColor.hexColor("#B2AAFF", alpha: 0.75).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ model: AVInfoSsnlistModel) {
        self.imgV.setImage(with: model.cover)
        self.nameL.text = model.title
        self.selectView.isHidden = !model.isSelect
        if model.isSelect {
            self.bgView.layer.borderWidth = 1
        } else {
            self.bgView.layer.borderWidth = 0
        }
    }
}
