//
//  HPPlayerSelectEpsCell.swift
//  HPPlixor
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPPlayerSelectEpsCell: UICollectionViewCell {
    @IBOutlet weak var titleL: UILabel!
    
    var model: AVEpsModel = AVEpsModel() {
        didSet {
            refreshData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func refreshData() {
        self.titleL.text = "\(self.model.eps_num)"
        if self.model.isSelect {
            self.titleL.backgroundColor = UIColor.hexColor("#7061FF", alpha: 0.05)
            self.titleL.layer.borderColor = UIColor.hexColor("#B2AAFF").cgColor
            self.titleL.layer.borderWidth = 1
        } else {
            self.titleL.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
            self.titleL.layer.borderWidth = 0
        }
    }
}
