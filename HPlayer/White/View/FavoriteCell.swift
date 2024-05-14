//
//  FavoriteCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/9.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var starL: UILabel!
    
    @IBOutlet weak var likeV: UIImageView!
    
    @IBOutlet weak var fView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgV.layer.cornerRadius = 4
        self.imgV.layer.masksToBounds = true
        self.fView.layer.cornerRadius = 13
        self.fView.layer.masksToBounds = true
    }

    func setModel(_ model: IndexDataListModel) {
        self.imgV.setImage(with: model.cover)
        self.titleL.text = model.title
        if let r = Float(model.rate) {
            self.starL.isHidden = false
            let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Open Sans", size: 24) ?? UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor.hexColor("#B2AAFF")]
            self.starL.attributedText = NSAttributedString(string: String(format: "%.1f", r), attributes: attr)
            self.starL.text = String(format: "%.1f", r)
        } else {
            self.starL.isHidden = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
