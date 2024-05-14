//
//  IndexSearchRecordView.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class IndexSearchRecordView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBAction func clickDeleteAction(_ sender: Any) {
        self.clickDeleteBlock?()
    }
    
    let cellIdentifier = "1"
    var list: [String] = []
    var clickDeleteBlock: (() -> Void)?
    var clickBlock: ((_ text: String) -> Void)?
    private lazy var layout: HPPlayLayout = {
        $0.delegate = self
        return $0
    }(HPPlayLayout())
    
    
    class func view() -> IndexSearchRecordView {
        let view = Bundle.main.loadNibNamed(String(describing: IndexSearchRecordView.self), owner: nil)?.first as! IndexSearchRecordView
        view.addLayout()
        return view
    }
    
    func addLayout() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: kBottomSafeHeight, right: 12)
        collectionView.setCollectionViewLayout(self.layout, animated: false)
        collectionView.register(UINib(nibName: String(describing: AVPlayHeadCategoryCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func refreshData() {
        if let arr = UserDefaults.standard.object(forKey: HPKey.searchRecord) as? [String] {
            self.list = arr
            self.isHidden = arr.count == 0 
        } else {
            self.isHidden = true
        }
        collectionView.reloadData()
    }
}

extension IndexSearchRecordView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVPlayHeadCategoryCell
        if let str = self.list.indexOfSafe(indexPath.item) {
            cell.nameL.text = str
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        if let str = self.list.indexOfSafe(indexPath.item) {
            w = str.getStrW(font: UIFont.systemFont(ofSize: 14), h: 24)
        }
        return CGSize(width: w + 28, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let str = self.list.indexOfSafe(indexPath.item) {
            self.clickBlock?(str)
        }
    }
}

extension IndexSearchRecordView: HPPlayLayoutDelegate {
    func playLayoutSizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        if let str = self.list.indexOfSafe(indexPath.item) {
            w = str.getStrW(font: UIFont.systemFont(ofSize: 14), h: 24)
        }
        return CGSize(width: w + 28, height: 38)
    }
    
    func playLayoutLineHeight() -> CGFloat {
        38
    }
    
    func playLayoutLineWidth() -> CGFloat {
        kScreenWidth - 24
    }
    
    func playLayoutSpacingBetweenItems(inSection section: Int) -> CGFloat {
        12
    }
    
    func playLayoutSpacingBetweenLines(inSection section: Int) -> CGFloat {
        16
    }
    
    func playLayoutLineInsetLeft(inSection section: Int) -> CGFloat {
        12
    }
    
    func playLayoutLineInsetRight(inSection section: Int) -> CGFloat {
        12
    }
}
