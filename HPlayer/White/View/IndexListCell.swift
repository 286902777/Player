//
//  IndexListCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/3.
//

import UIKit

class IndexListCell: UITableViewCell {
    let cellW = floor((kScreenWidth - 48) / 3)
    let cellIdentifier = "IndexCell"
    let peopleCellIdentifier = "PeopleCell"

    typealias clickMoreBlock = () -> Void
    var clickMoreHandle : clickMoreBlock?
    var type: IndexDataType = .list
    var list: [IndexDataListModel] = []
    typealias clickBlock = (_ model: IndexDataListModel) -> Void
    var clickHandle : clickBlock?
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var moreL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: IndexCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(UINib(nibName: String(describing: PeopleCell.self), bundle: nil), forCellWithReuseIdentifier: peopleCellIdentifier)
        moreBtn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        moreL.attributedText = NSAttributedString(string: "More", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.hexColor("#CCC7FF"), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.hexColor("#CCC7FF")])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func clickAction() {
        self.clickMoreHandle?()
    }
    
    func setModel( model: IndexModel, clickMoreBlock: clickMoreBlock?, clickBlock: clickBlock?) {
        self.titleL.text = model.title
        self.type = model.type
        self.clickMoreHandle = clickMoreBlock
        self.clickHandle = clickBlock
        if let list = model.data.first?.data_list {
            self.list = list
            self.collectionView.reloadData()
        }
    }
}

extension IndexListCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(20, self.list.count) 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.type == .list {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! IndexCell
            if let model = self.list.indexOfSafe(indexPath.item) {
                cell.setModel(model: model)
                cell.clickLikeBlock = { like in
                    if like {
                        DBManager.share.insertWhiteData(mod: model)
                    } else {
                        DBManager.share.deleteWhiteData(model)
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleCellIdentifier, for: indexPath) as! PeopleCell
            if let model = self.list.indexOfSafe(indexPath.item) {
                cell.setModel(model: model)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item) {
            self.clickHandle?(model)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellW, height: cellW * 3 / 2 + 18)
    }
}
