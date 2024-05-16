//
//  HPPlayerSelectSsnCell.swift
//  HPPlixor
//
//  Created by HF on 2024/3/21.
//


import UIKit

class HPPlayerSelectSsnCell: UICollectionViewCell {

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var nameL: UILabel!
    
    var model: AVInfoSsnlistModel = AVInfoSsnlistModel() {
        didSet {
            self.setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData() {
        if self.model.isSelect {
            self.nameL.font = .font(weigth: .medium, size: 18)
            self.nameL.textColor = UIColor.hexColor("#B2AAFF")
        } else {
            self.nameL.font = .font(size: 14)
            self.nameL.textColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        }
        self.selectView.isHidden = !self.model.isSelect
        self.nameL.text = self.model.title
    }
}
