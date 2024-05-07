//
//  AVListCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/3.
//

import UIKit

class AVListCell: UITableViewCell {
    let cellW = floor((kScreenWidth - 48) / 3)
    let cellIdentifier = "AVCell"
    typealias clickMoreBlock = () -> Void
    var clickMoreHandle : clickMoreBlock?
    var dataList: [AVDataInfoModel] = []
    typealias clickBlock = (_ movieModel: AVDataInfoModel) -> Void
    var clickHandle : clickBlock?
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    private var history: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: AVCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func moreAction() {
        self.clickMoreHandle?()
    }
    
    func setModel( model: AVHomeModel, clickMoreBlock: clickMoreBlock?, clickBlock: clickBlock?) {
        self.clickMoreHandle = clickMoreBlock
        self.clickHandle = clickBlock
//        if let mod = model.data.first {
            self.history = (model.name == "History" && model.id.isEmpty)
            self.titleL.text = model.name
            self.dataList = model.m20
            self.collectionView.reloadData()
//        }
    }
}

extension AVListCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(20, self.dataList.count) 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVCell
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            cell.setModel(model: model, self.history)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.dataList.indexOfSafe(indexPath.item) {
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
