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
    
    private var model: AVEpsModel = AVEpsModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.desL.isHidden = true
        self.imgV.layer.cornerRadius = 4
        self.imgV.layer.masksToBounds = true
        let attr = NSAttributedString(string: "Overview", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.hexColor("#CCC7FF"), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.hexColor("#CCC7FF")])
        overBtn.setAttributedTitle(attr, for: .normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setModel(_ model: AVEpsModel) {
        self.model = model
        self.imgV.setImage(with: model.cover)
        self.titleL.text = model.title
       
        self.yearL.text = "\(model.storage_timestamp)".timeStampToDateString(format: "MMM dd.yyyy")
        
        var h = 0
        var s = 0
        if model.runtime > 60 {
            h = model.runtime / 60
            s = model.runtime % 60
        } else {
            s = model.runtime
        }
        self.timeL.text = String(format: "%02d:%02d:%02d", h, s, 0)
        self.desL.text = model.overview
        
        if model.isSelect {
            self.imgVTop.constant = 8
            self.stackView.backgroundColor = UIColor.hexColor("#2E2E2E")
            self.arrowView.image = UIImage(named: "cell_more_down")
            self.desL.isHidden = false
        }
    }
    
    @IBAction func clickAction(_ sender: Any) {
        if self.model.isSelect == false {
            self.clickBlock?()
        }
    }
    
}
