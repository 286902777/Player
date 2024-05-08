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
            self.refreshData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
    }

    func refreshData() {
        self.nameL.text = self.model.display_name
        if self.model.isSelect {
            self.bgView.layer.borderWidth = 1
            self.bgView.backgroundColor = UIColor.hexColor("#7061FF", alpha: 0.05)
            self.bgView.layer.borderColor = UIColor.hexColor("#B2AAFF").cgColor
        } else {
            self.bgView.layer.borderWidth = 0
            self.bgView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
