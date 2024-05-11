//
//  PlayDoubleImgCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlayDoubleImgCell: UITableViewCell {

    @IBOutlet weak var leftV: UIImageView!
    
    @IBOutlet weak var rightV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftV.layer.cornerRadius = 4
        self.leftV.layer.masksToBounds = true
        self.rightV.layer.cornerRadius = 4
        self.rightV.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
