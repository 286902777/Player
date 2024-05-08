//
//  AVPlayHeadInfoCell.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVPlayHeadInfoCell: UITableViewCell {

    @IBOutlet weak var infoL: UILabel!
    
    @IBOutlet weak var collectH: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var list: [AVCastsModel] = [] {
        didSet {
            collectH.constant = list.count == 0 ? 0 : 120
        }
    }
    private let cellIdentifier = "AVPlayHeadIconCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: String(describing: AVPlayHeadIconCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setModel(_ model: AVMoreModel) {
        self.list = model.celebrity_list
        self.infoL.text = model.description
        self.collectionView.reloadData()
    }
}

extension AVPlayHeadInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVPlayHeadIconCell
        if let mod = self.list.indexOfSafe(indexPath.item) {
            cell.model = mod
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
