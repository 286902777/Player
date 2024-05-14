//
//  ListViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    let cellW = floor((kScreenWidth - 36) / 3)
    var name: String = ""
    var isMovie: Bool = false
    var list: [AVDataInfoModel] = []
    let cellIdentifier = "IndexCellIdentifier"
    private var page: Int = 1
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 16, right: 12)
        collectionView.register(UINib(nibName: String(describing: IndexCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefresh()
        requestData()
        NotificationCenter.default.addObserver(forName: HPKey.Noti_Like, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setUI() {
        navBar.titleL.isHidden = false
        navBar.titleL.text = self.name
        navBar.rightBtn.isHidden = true
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(collectionView)
        }
        self.emptyView.setType()
    }
    
    func addRefresh() {
        let footer = RefreshAutoNormalFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.requestData()
        }
        collectionView.mj_footer = footer
    }
    
    override func reSetRequest() {
        self.page = 1
        self.list.removeAll()
        self.requestData()
    }
    
    func requestData() {
        if HPConfig.share.isNetWork == false {
            self.collectionView.mj_header?.endRefreshing()
            self.emptyView.isHidden = false
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.list.removeAll()
                self.collectionView.reloadData()
            }
            return
        }
        HPProgressHUD.show()
        PlayerNetAPI.share.AVFilterInfoData(type: self.isMovie ? "1" : "2", page: self.page) { [weak self] success, list in
            HPProgressHUD.dismiss()
            guard let self = self else { return }
            if !success {
                self.emptyView.isHidden = false
            } else {
                self.list.append(contentsOf: list)
                self.emptyView.isHidden = true
            }
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
            if list.count == 0 {
                self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                self.collectionView.mj_footer?.isHidden = true
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! IndexCell
        if let model = self.list.indexOfSafe(indexPath.item) {
            cell.setPlayModel(model: model)
            cell.clickLikeBlock = { like in
                let mod = IndexDataListModel()
                mod.id = model.id
                mod.type = model.type
                mod.title = model.title
                mod.cover = model.cover
                mod.rate = model.rate
                if like {
                    DBManager.share.insertWhiteData(mod: mod)
                } else {
                    DBManager.share.deleteWhiteData(mod)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item) {
            let mod = IndexDataListModel()
            mod.id = model.id
            mod.type = model.type
            mod.title = model.title
            mod.cover = model.cover
            mod.rate = model.rate
            let vc = PlayViewController(model: mod)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellW, height: cellW * 3 / 2 + 18)
    }
}
