//
//  AVFilterViewController.swift
//  HPlayer
//
//  Created by HF on 2024/4/3.
//

import UIKit

class AVFilterViewController: VBaseViewController {
    let cellIdentifier = "AVCellIdentifier"
    let cellWidth = floor((kScreenWidth - 36) / 3)
    var list: [AVDataInfoModel?] = []
    var filterList: [[AVFilterCategoryInfoModel]] = []
    private var type: String = ""
    private var videoType: String = ""
    private var genre: String = ""
    private var year: String = ""
    private var cntyno: String = ""
    private var page: Int = 1
    private var HeadHeight: CGFloat = 216
    
    private let categroyView: AVFilterView = AVFilterView(frame: CGRect(x: 0, y: -216, width: kScreenWidth - 32, height: 216))

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.contentInset = UIEdgeInsets(top: 216, left: 12, bottom: 16, right: 12)
        collectionView.register(UINib(nibName: String(describing: AVCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(AVFilterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AVFilterView")
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var showView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "filter_show_Bg")
        view.isHidden = true
        return view
    }()
    private lazy var showLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.text = "Movies · Action · 2023 · United"
        label.font = .font(weigth: .medium, size: 14)
        return label
    }()
    private var currentTime: TimeInterval = Date().timeIntervalSince1970

    private var first: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.currentTime = Date().timeIntervalSince1970
        if self.first == false {
            HPLog.tb_explore_sh(loadsuccess: "1")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.first = false
        HPLog.tb_explore_len(len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setRefresh()
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                HPLog.tb_explore_len(len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
            }
        }
    }
    func setUpUI() {
        self.navBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.hexColor("#141414")
        let search = AVFilterSearchView.view()
        search.clickBlock = { [weak self] in
            guard let self = self else { return }
            self.pushSearch()
        }
        view.addSubview(search)
        search.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(54)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(search.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        collectionView.addSubview(categroyView)
        view.addSubview(showView)
        showView.addSubview(showLabel)
        showView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(search).offset(72)
        }
        showLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(72)
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(collectionView)
        }
        self.emptyView.setType()

        view.insertSubview(collectionView, at: 1)
        view.insertSubview(emptyView, at: 2)
        view.insertSubview(showView, at: 3)
        view.insertSubview(navBar, at: 4)
    }
    
    func setRefresh() {
        let header = RefreshFilterGifHeader { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.filterList.removeAll()
            self.list.removeAll()
            self.showLabel.text = ""
            self.requestData()
            self.type = ""
            self.genre = ""
            self.year = ""
            self.cntyno = ""
            self.loadMoreData()
        }
        
        collectionView.mj_header = header
        let footer = RefreshAutoNormalFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.loadMoreData()
        }
        collectionView.mj_footer = footer
        collectionView.mj_header?.beginRefreshing()
    }
    
    override func reSetRequest() {
        self.collectionView.mj_header?.beginRefreshing()
    }
    
    func requestData() {
        PlayerNetAPI.share.AVFilterHeadInfo {[weak self] success, model in
            guard let self = self else { return }
            var typeArr: [AVFilterCategoryInfoModel] = []
            for (index, item) in model.type_list.enumerated() {
                let mod = AVFilterCategoryInfoModel()
                mod.title = item
                if index == 0 {
                    mod.isSelect = true
                }
                typeArr.append(mod)
            }
            
            var genreArr: [AVFilterCategoryInfoModel] = []
            model.genre_list.insert("All Genres", at: 0)
            for (index, item) in model.genre_list.enumerated() {
                let mod = AVFilterCategoryInfoModel()
                mod.title = item
                if index == 0 {
                    mod.isSelect = true
                }
                genreArr.append(mod)
            }
            
            var yearArr: [AVFilterCategoryInfoModel] = []
            model.year_list.insert("All Release Years", at: 0)
            for (index, item) in model.year_list.enumerated() {
                let mod = AVFilterCategoryInfoModel()
                mod.title = item
                if index == 0 {
                    mod.isSelect = true
                }
                yearArr.append(mod)
            }
            
            var countryArr: [AVFilterCategoryInfoModel] = []
            model.country_list.insert("All Countries", at: 0)
            for (index, item) in model.country_list.enumerated() {
                let mod = AVFilterCategoryInfoModel()
                mod.title = item
                if index == 0 {
                    mod.isSelect = true
                }
                countryArr.append(mod)
            }
            self.filterList.append(typeArr)
            self.filterList.append(genreArr)
            self.filterList.append(yearArr)
            self.filterList.append(countryArr)
            DispatchQueue.main.async {
                self.setfilterHead()
            }
        }
    }
    
    private func setfilterHead() {
        self.categroyView.setModel(self.filterList) { [weak self] type, title, idx in
            guard let self = self else { return }
            switch type {
            case .type:
                switch idx {
                case 0:
                    self.type = ""
                case 1:
                    self.type = "1"
                default:
                    self.type = "2"
                }
                self.videoType = title
            case .genre:
                self.genre = idx == 0 ? "" : title
            case .year:
                self.year = idx == 0 ? "" : title
            case .country:
                self.cntyno = idx == 0 ? "" : title
            }
            self.setSelectInfo()
            self.requestFilterData()
        }
    }
    
    private func setSelectInfo() {
        var arr: [String] = []
        for items in self.filterList {
            for (index, item) in items.enumerated() {
                if index > 0, item.isSelect == true {
                    arr.append(item.title)
                }
            }
        }
        self.showLabel.text = arr.joined(separator: " · ")
    }
    private func requestFilterData() {
        self.collectionView.mj_footer?.isHidden = false
        self.page = 1
        self.list.removeAll()
        self.loadMoreData()
    }
    
    private func loadMoreData() {
        if HPConfig.share.isNetWork == false {
            self.collectionView.mj_header?.endRefreshing()
            self.emptyView.isHidden = false
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.isHidden = true
                self.list.removeAll()
                self.collectionView.reloadData()
            }
            return
        }
        PlayerNetAPI.share.AVFilterInfoData(genre: self.genre, year: self.year, cntyno: self.cntyno, type: self.type, page: self.page) { [weak self] success, list in
            guard let self = self else { return }
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
            if list.count == 0 {
                self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
            }
            if !success {
                self.collectionView.isHidden = true
                self.emptyView.isHidden = false
            } else {
                self.collectionView.isHidden = false
                self.emptyView.isHidden = true
                if list.count > 0 {
                    self.list.append(contentsOf: list)
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func pushSearch() {
        let vc = AVSearchViewController()
        vc.from = .explore
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AVFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVCell
        if let model = self.list.indexOfSafe(indexPath.item), let m = model {
            cell.setModel(model: m)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item), let m = model {
            let g = self.genre.isEmpty ? "all" : self.genre
            let y = self.year.isEmpty ? "all" : self.year
            let c = self.cntyno.isEmpty ? "all" : self.cntyno
            let t = self.videoType.isEmpty ? "all" : self.videoType

            HPLog.tb_explore_cl(kid: "1", type: t, genres: g, year: y, country: c, c_id: m.id, c_name: m.title)

            DBManager.share.updateData(m)
            PlayerManager.share.openPlayer(vc: self, id: m.id, from: .explore)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellWidth * 3 / 2 + 18)
    }
}

extension AVFilterViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.showLabel.text?.count == 0 {
            self.showView.isHidden = true
            self.backView.isHidden = false
            return
        }
        
        if scrollView.contentOffset.y > 0 {
            self.showView.isHidden = false
            self.backView.isHidden = true
        } else {
            self.showView.isHidden = true
            self.backView.isHidden = false
        }
    }
}
