//
//  AVListViewController.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVListViewController: VBaseViewController {
    let cellW = floor((kScreenWidth - 36) / 3)
    var name: String = ""
    var listId: String = ""
    var dataList: [AVDataInfoModel] = []
    let cellIdentifier = "AVCellIdentifier"
    private var page: Int = 1
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 16, right: 12)
        collectionView.register(UINib(nibName: String(describing: AVCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
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
        setUI()
        addRefresh()
        initData()
    }
    
    func setUI() {
        navBar.titleL.text = self.name
        navBar.rightBtn.setImage(UIImage(named: "nav_search"), for: .normal)
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
            self.initData()
        }
        collectionView.mj_footer = footer
    }
    
    override func clickRightAction() {
        let vc = AVSearchViewController()
        vc.from = .list
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func reSetRequest() {
        self.page = 1
        self.dataList.removeAll()
        self.initData()
    }
    
    func initData() {
        if HPConfig.share.isNetWork == false {
            self.collectionView.mj_header?.endRefreshing()
            self.emptyView.isHidden = false
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dataList.removeAll()
                self.collectionView.reloadData()
            }
            return
        }
        HPProgressHUD.show()
        PlayerNetAPI.share.AVMoreList(id: self.listId, page: self.page) { [weak self] success, list in
            HPProgressHUD.dismiss()
            guard let self = self else { return }
            if !success {
                self.emptyView.isHidden = false
            } else {
                if list.count > 0 {
                    self.dataList.append(contentsOf: list)
                }
                if self.dataList.count == 0 {
                    self.emptyView.isHidden = true
                }
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

extension AVListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVCell
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            cell.setModel(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            DBManager.share.updateData(model)
            PlayerManager.share.openPlayer(vc: self, id: model.id, from: .list)
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
