//
//  HPPlayEpsListCell.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPPlayEpsListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var epsL: UILabel!
    @IBOutlet weak var numL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    
    var model: AVEpsModel = AVEpsModel() {
        didSet {
            self.setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 12
        self.bgView.layer.masksToBounds = true
    }

    func setData() {
        let arr: [String] = self.model.title.components(separatedBy: ":")
        if let sub = arr.first {
            let subArr = sub.components(separatedBy: " ")
            self.epsL.text = subArr.first
            self.numL.text = subArr.last
            self.nameL.text = arr.last
        }
     
        if self.model.isSelect {
            self.bgView.backgroundColor = UIColor.hexColor("#7061FF", alpha: 0.05)
            self.bgView.layer.borderColor = UIColor.hexColor("#B2AAFF").cgColor
            self.bgView.layer.borderWidth = 1
        } else {
            self.bgView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
            self.bgView.layer.borderWidth = 0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
