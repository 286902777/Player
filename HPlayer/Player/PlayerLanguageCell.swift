//
//  PlayerLanguageCell.swift
//  HPlayer
//
//  Created by HF on 2024/2/9.
//


import UIKit

class PlayerLanguageCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var nameL: UILabel!
    
    var model: AVCaption = AVCaption() {
        didSet {
            self.setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
    }

    func setData() {
        if self.model.isSelect {
            self.bgView.backgroundColor = UIColor.hexColor("#7061FF", alpha: 0.05)
            self.bgView.layer.borderColor = UIColor.hexColor("#B2AAFF").cgColor
            self.bgView.layer.borderWidth = 1
        } else {
            self.bgView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
            self.bgView.layer.borderWidth = 0
        }
        self.nameL.text = self.model.display_name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
