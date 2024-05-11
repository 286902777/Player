//
//  PlaySeasonListCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlaySeasonListCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var yearL: UILabel!
    
    @IBOutlet weak var overBtn: UIButton!
    
    @IBOutlet weak var arrowView: UIImageView!
    
    @IBOutlet weak var desL: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var imgVTop: NSLayoutConstraint!
    
    @IBOutlet weak var timeL: UILabel!
    
    var clickBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.desL.isHidden = true
        let attr = NSAttributedString(string: "Overview", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.hexColor("#CCC7FF"), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.hexColor("#CCC7FF")])
        overBtn.setAttributedTitle(attr, for: .normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func clickAction(_ sender: Any) {
        if self.desL.isHidden == false {
            return
        } 
        self.imgVTop.constant = 8
        self.stackView.backgroundColor = UIColor.hexColor("#2E2E2E")
        self.arrowView.image = UIImage(named: "cell_more_down")
        self.desL.isHidden = false
        self.clickBlock?()
    }
    
}
