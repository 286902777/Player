//
//  PlayMaxImgCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlayMaxImgCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgV.layer.cornerRadius = 4
        self.imgV.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUrl(_ url: String) {
        self.imgV.setImage(with: url)
    }
}
