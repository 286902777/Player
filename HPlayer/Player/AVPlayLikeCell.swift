//
//  AVPlayLikeCell.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVPlayLikeCell: UITableViewCell {
    private let cellWidth = floor((kScreenWidth - 36 - 18) / 3)

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectH: NSLayoutConstraint!
    private let cellIdentifier = "AVCell"
    typealias clickBlock = (_ index: Int) -> Void
    var clickHandle : clickBlock?

    var list: [AVDataInfoModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectH.constant = cellWidth * 3 / 2 + 18
        collectionView.register(UINib(nibName: String(describing: AVCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setModel(_ model: AVMoreListModel, clickBlock: clickBlock?) {
        self.clickHandle = clickBlock
        self.titleL.text = model.title
        self.list = model.data_list
        self.collectionView.reloadData()
    }
}

extension AVPlayLikeCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVCell
        if let model = self.list.indexOfSafe(indexPath.item) {
            cell.setModel(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clickHandle?(indexPath.item)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellWidth * 3 / 2 + 18)
    }
}
