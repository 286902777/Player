//
//  AVPlayHeadCell.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import UIKit

class AVPlayHeadCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var scroL: UILabel!
    
    @IBOutlet weak var yearL: UILabel!
    
    @IBOutlet weak var ctrNoL: UILabel!
    
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var collectH: NSLayoutConstraint!
    
    typealias refreshBlock = () -> Void
    var refreshHandle : refreshBlock?
    typealias clickMoreBlock = (_ show: Bool) -> Void
    var clickMoreHandle : clickMoreBlock?
    
    var dataArr: [String] = []
    private let cellIdentifier = "AVPlayHeadCategoryCell"
    private var height: CGFloat = 0 {
        didSet {
            if height != oldValue, height > 0 {
                self.refreshHandle?()
            }
        }
    }
    private lazy var layout: HPPlayLayout = {
        $0.delegate = self
        return $0
    }(HPPlayLayout())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.midView.layer.cornerRadius = 2
        self.midView.layer.masksToBounds = true
        scroL.font = UIFont(name: "Bebas Neue Regular", size: 32)
        collectionView.setCollectionViewLayout(self.layout, animated: false)
        collectionView.register(UINib(nibName: String(describing: AVPlayHeadCategoryCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func clickMoreBtn(_ sender: Any) {
        self.moreBtn.isSelected = !self.moreBtn.isSelected
        self.clickMoreHandle?(self.moreBtn.isSelected)
    }
    
    func setModel(_ model: AVMoreModel, moreSelect: Bool = false, clickMoreBlock: clickMoreBlock?, refreshBlock: refreshBlock?) {
        if model.title.count == 0 {
            return
        }
        self.contentView.isHidden = false
        self.moreBtn.isSelected = moreSelect
        self.clickMoreHandle = clickMoreBlock
        self.refreshHandle = refreshBlock
        self.titleL.text = model.title
        if let r = Float(model.rate) {
            self.scroL.isHidden = false
            self.scroL.text = String(format: "%.1f", r)
        } else {
            self.scroL.isHidden = true
        }
        if model.pub_date.count >= 4 {
            self.yearL.text = model.pub_date.substring(to: 4)
        }
        self.ctrNoL.text = model.country
        self.dataArr = model.genre_list
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectH.constant = self.collectionView.contentSize.height
        self.height = self.collectionView.contentSize.height
    }
}

extension AVPlayHeadCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVPlayHeadCategoryCell
        if let str = self.dataArr.indexOfSafe(indexPath.item) {
            cell.nameL.text = str
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        if let str = self.dataArr.indexOfSafe(indexPath.item) {
            w = str.getStrW(font: UIFont.systemFont(ofSize: 12), h: 16)
        }
        return CGSize(width: w + 16, height: 24)
    }
}

extension AVPlayHeadCell: HPPlayLayoutDelegate {
    func playLayoutSizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        if let str = self.dataArr.indexOfSafe(indexPath.item) {
            w = str.getStrW(font: UIFont.systemFont(ofSize: 12), h: 16)
        }
        return CGSize(width: w + 16, height: 24)
    }
    
    func playLayoutLineHeight() -> CGFloat {
        24
    }
    
    func playLayoutLineWidth() -> CGFloat {
        kScreenWidth - 104
    }
    
    func playLayoutSpacingBetweenItems(inSection section: Int) -> CGFloat {
        8
    }
    
    func playLayoutSpacingBetweenLines(inSection section: Int) -> CGFloat {
        8
    }
    
    func playLayoutLineInsetLeft(inSection section: Int) -> CGFloat {
        16
    }
}
