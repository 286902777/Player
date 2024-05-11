//
//  IndexViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/8.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import MJRefresh
import JXBanner
import JXPageControl

class IndexViewController: BaseViewController {
    let cellIdentifier = "IndexListCell"
    let IndexBannerCellID = "IndexBannerCell"
    private var list: [AVHomeModel] = []
    private var bannerList: [AVDataInfoModel] = []
    private var bgView: AVBannerEffectView = AVBannerEffectView()
        
    var headView: IndexHeadView = IndexHeadView(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth + 24))
    
    lazy var bannerView: JXBanner = {[weak self] in
        let banner = JXBanner()
        banner.placeholderImgView.image = UIImage(named: "banner_placeholder")
        banner.delegate = self
        banner.dataSource = self
        return banner
    }()
    
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(UINib(nibName: String(describing: IndexListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInset = .zero
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var showEffect: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func refreshHistoryData() {
        let arr = DBManager.share.selectHistoryDatas()
        if let m = self.list.first, m.name == "History" {
            list.removeFirst()
        }
        if arr.count > 0 {
            let model = AVHomeModel()
            model.name = "History"
            model.m20 = arr
            self.list.insert(model, at: 0)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefresh()
    }
    
    override func setUI() {
        self.navBar.setBackHidden(true)
        self.navBar.rightBtn.setImage(UIImage(named: "w_nav_search"), for: .normal)
        self.navBar.leftL.isHidden = false
        self.navBar.leftL.text = "Trending"
        
        view.addSubview(bgView)
        bgView.isHidden = true
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTopSafeHeight + 30 + kScreenWidth)
        }
        bgView.setEffect()

        self.headView.addSubview(self.bannerView)
        self.headView.clickBlock = { [weak self] isDay in
            guard let self = self else { return }
            
        }
        self.bannerView.snp.makeConstraints { make in
            make.top.equalTo(48)
            make.left.right.bottom.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.tableHeaderView = self.headView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(tableView)
        }
        self.emptyView.setType()
        
        view.insertSubview(bgView, at: 0)
        view.insertSubview(tableView, at: 1)
        view.insertSubview(emptyView, at: 2)
        view.insertSubview(self.navBar, at: 3)
    }
    
    func addRefresh() {
        let header = RefreshGifHeader { [weak self] in
            guard let self = self else { return }
            self.configData()
        }
        tableView.mj_header = header
        self.tableView.mj_header?.beginRefreshing()
    }
        
    override func reSetRequest() {
        HPProgressHUD.dismiss()
        tableView.mj_header?.beginRefreshing()
    }
    
    func configData() {
        self.list.removeAll()
        self.bannerList.removeAll()
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        group.enter()
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVBannerList { success, list in
                if success {
                    self.bannerList = list
                } else {
                    self.showEffect = false
                }
                group.leave()
            }
        }
        group.enter()
        dispatchQueue.async {[weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVIndexList { success, list in
                if !success {
                    self.showEffect = false
                } else {
                    if list.count > 0 {
                        self.list = list
                    }
                }
                self.tableView.mj_header?.endRefreshing()
                group.leave()
            }
        }
        group.notify(queue: dispatchQueue){ [weak self] in
            guard let self = self else { return }
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.bannerList.count > 0, self.list.count > 0 {
                self.emptyView.isHidden = true
                self.headView.isHidden = false
                self.tableView.isHidden = false
                self.bannerView.reloadView()
            } else {
                self.emptyView.isHidden = false
                self.bgView.isHidden = true
                self.tableView.isHidden = true
                self.headView.isHidden = true
            }
            self.tableView.reloadData()
            if self.bannerList.count > 0 {
                self.showEffect = true
                self.bgView.isHidden = false
            }
        }
    }
    
    override func rightAction() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension IndexViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:IndexListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! IndexListCell
        if let model = self.list.indexOfSafe(indexPath.row) {
            cell.setModel(model: model, clickMoreBlock: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let vc = ListViewController()
                    vc.name = model.name
                    vc.listId = model.id
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, clickBlock: { movieModel in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let vc = PlayViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let H = ceil((kScreenWidth - 36) / 3 * 3 / 2) + 69
        return H
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

//MARK:- JXBannerDataSource
extension IndexViewController: JXBannerDataSource {
    
    func jxBanner(_ banner: JXBannerType)
        -> (JXBannerCellRegister) {
            return JXBannerCellRegister(type: IndexBannerCell.self,
                                        reuseIdentifier: IndexBannerCellID)
    }
    
    func jxBanner(numberOfItems banner: JXBannerType)
    -> Int { return self.bannerList.count }
    
    func jxBanner(_ banner: JXBannerType,
                  cellForItemAt index: Int,
                  cell: UICollectionViewCell)
        -> UICollectionViewCell {
            let tempCell = cell as! IndexBannerCell
            if let model = self.bannerList.indexOfSafe(index) {
                tempCell.setModel(model)
            }
            return tempCell
    }
    
    func jxBanner(_ banner: JXBannerType,
                  params: JXBannerParams)
        -> JXBannerParams {
            return params
                .timeInterval(3)
                .cycleWay(.forward)
                .isAutoPlay(true)
    }
    
    func jxBanner(_ banner: JXBannerType,
                  layoutParams: JXBannerLayoutParams)
        -> JXBannerLayoutParams {
            let w = kScreenWidth - 24
            return layoutParams
                .layoutType(JXBannerTransformLinear())
                .itemSize(CGSize(width: w, height: w))
                .itemSpacing(24)
                .rateOfChange(0.1)
                .minimumScale(0.95)
                .rateHorisonMargin(0.5)
                .minimumAlpha(0.9)
    }
    
    func jxBanner(pageControl banner: JXBannerType,
                  numberOfPages: Int,
                  coverView: UIView,
                  builder: JXBannerPageControlBuilder) -> JXBannerPageControlBuilder {
        let pageControl = JXPageControlScale()
        pageControl.contentMode = .bottom
        pageControl.activeSize = CGSize(width: 9, height: 3)
        pageControl.inactiveSize = CGSize(width: 3, height: 3)
        pageControl.activeColor = UIColor.white
        pageControl.inactiveColor = UIColor.hexColor("#FFFFFF", alpha: 0.3)
        pageControl.columnSpacing = -2
        pageControl.isAnimation = true
        builder.pageControl = pageControl
        builder.layout = {
            pageControl.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(coverView)
                maker.bottom.equalTo(coverView.snp.bottom).offset(-8)
                maker.height.equalTo(3)
            }
        }
        return builder
    }
    
    func jxBanner(_ banner: JXBannerType, centerIndex: Int, centerCell: UICollectionViewCell) {

    }
    
    func jxBanner(_ banner: JXBannerType, lastCenterIndex: Int?, lastCenterCell: UICollectionViewCell?) {
    }
}

//MARK:- JXBannerDelegate
extension IndexViewController: JXBannerDelegate {
    public func jxBanner(_ banner: JXBannerType,
                         didSelectItemAt index: Int) {
        if let model = self.bannerList.indexOfSafe(index) {
            DBManager.share.updateData(model)
            PlayerManager.share.openPlayer(vc: self, id: model.id, from: .banner)
        }
    }
    
    func jxBanner(_ banner: JXBannerType, coverView: UIView) {

    }
    
    func jxBanner(_ banner: JXBannerType, center index: Int) {

    }
}

extension IndexViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            self.bgView.isHidden = true
        } else {
            self.bgView.alpha = (10 - scrollView.contentOffset.y) / 10
            if self.showEffect {
                self.bgView.isHidden = false
            }
        }
    }
}
