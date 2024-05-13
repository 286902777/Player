//
//  PlayDetailsCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlayDetailsCell: UITableViewCell {

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var starL: UILabel!
    
    @IBOutlet weak var yearL: UILabel!
    
    @IBOutlet weak var contryL: UILabel!
    
    @IBOutlet weak var typeL: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var desL: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "PlayPeopleCell"
    var list: [IndexDataListModel] = []
    var clickBlock: ((_ share: Bool) -> Void)?
    var clickLikeBlock: ((_ like: Bool) -> Void)?
    var clickItemBlock: ((_ model: IndexDataListModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareBtn.layer.borderColor = UIColor.hexColor("#979797", alpha: 0.75).cgColor
        editBtn.layer.borderColor = UIColor.hexColor("#979797", alpha: 0.75).cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: PlayPeopleCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.starL.font = UIFont(name: "Open Sans Bold", size: 24)

    }

    func setModel(_ model: AVModel, _ list: [IndexDataListModel]) {
        self.nameL.text = model.title
        if let r = Float(model.rate) {
            self.starL.isHidden = false
            self.starL.text = String(format: "%.1f", r)
        } else {
            self.starL.isHidden = false
            self.starL.text = "8.0"
        }
        if model.pub_date.count >= 4 {
            self.yearL.text = model.pub_date.substring(to: 4)
        }
        self.contryL.text = model.country
        self.typeL.text = model.genre_list.joined(separator: " / ")
        self.desL.text = model.description
        self.list = list
        let f = DBManager.share.findWhiteDataWithModel(id: model.id)
        self.likeBtn.isSelected = f
        self.collectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickLikeAction(_ sender: Any) {
        self.likeBtn.isSelected = !self.likeBtn.isSelected
        self.clickLikeBlock?(self.likeBtn.isSelected)
    }
    
    @IBAction func clickShareAction(_ sender: Any) {
        self.clickBlock?(true)
    }
    
    @IBAction func clickEditAction(_ sender: Any) {
        self.clickBlock?(false)
    }
    
}

extension PlayDetailsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlayPeopleCell
        if let model = self.list.indexOfSafe(indexPath.item) {
            cell.setModel(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item) {
            self.clickItemBlock?(model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 180)
    }
}
