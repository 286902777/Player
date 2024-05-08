//
//  AVPlaySsnHeadView.swift
//  HPlayer
//
//  Created by HF on 2024/3/18.
//

import UIKit

class AVPlaySsnHeadView: UIView {
    private let cellIdentifier = "HPPlayerSelectSsnCell"
    private var list: [AVInfoSsnlistModel?] = []
    
    lazy var lineL: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.register(UINib(nibName: String(describing: HPPlayerSelectSsnCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    typealias clickBlock = (_ id: String) -> Void
    var clickHandle : clickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        self.backgroundColor = UIColor.hexColor("#141414")
        self.addSubview(collectionView)
        self.addSubview(lineL)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        self.lineL.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom)
            make.height.equalTo(1)
            make.bottom.equalTo(-15)
        }
    }
    
    func setModel(_ list: [AVInfoSsnlistModel?], clickBlock: clickBlock?) {
        self.clickHandle = clickBlock
        self.list = list
        self.collectionView.reloadData()
        for (index, item) in self.list.enumerated() {
            if let m = item, m.isSelect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
                }
            }
        }
    }
}

extension AVPlaySsnHeadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HPPlayerSelectSsnCell
        if let model = self.list.indexOfSafe(indexPath.item), let m = model {
            cell.model = m
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item), let m = model {
            self.clickHandle?(m.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat = 0
        if let m = self.list.indexOfSafe(indexPath.item), let model = m {
            if model.isSelect {
                w = model.title.getStrW(font: .font(weigth: .medium, size: 18), h: 36)
            } else {
                w = model.title.getStrW(font: .font(size: 14), h: 36)
            }
        }
        return CGSize(width: w + 2, height: 36)
    }
}
