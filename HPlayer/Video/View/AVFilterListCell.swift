//
//  AVFilterListCell.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//


import UIKit

class AVFilterListCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list: [AVFilterCategoryInfoModel] = []
    let cellIdentifier = "AVFilterCellIdentifier"
    typealias clickBlock = (_ title: String, _ idx: Int) -> Void
    var clickHandle : clickBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: AVFilterCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }  
    func setModel(_ arr: [AVFilterCategoryInfoModel], clickBlock: clickBlock?) {
        self.clickHandle = clickBlock
        if let m = arr.first {
            m.isSelect = true
        }
        self.list = arr
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: false)
    }
}

extension AVFilterListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVFilterCell
        if let model = list.indexOfSafe(indexPath.item) {
            cell.model = model
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = list.map{$0.isSelect = false}
        list[indexPath.item].isSelect = true
        self.collectionView.reloadData()
        
        self.clickHandle?(list[indexPath.item].title, indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let mod = self.list.indexOfSafe(indexPath.item) {
            return CGSize(width: mod.isSelect ? (mod.width + 16) : mod.width, height: 50)
        }
        return CGSize.zero
    }
}
