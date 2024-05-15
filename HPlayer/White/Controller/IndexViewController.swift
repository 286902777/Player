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
    private var bannerlist: [IndexDataModel] = []
    private var list: [IndexModel] = []
    private var peopleModel: IndexModel = IndexModel()
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
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kNavBarHeight, right: 0)
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var showEffect: Bool = false
    private var isDay: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.bannerView.reloadView()
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
            self.isDay = isDay
            self.bannerView.reloadView()
        }
        self.bannerView.snp.makeConstraints { make in
            make.top.equalTo(48)
            make.left.right.bottom.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.tableHeaderView = self.headView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(kScreenHeight - kNavBarHeight)
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        self.emptyView.setType()
        
        view.insertSubview(backView, at: 0)
        view.insertSubview(bgView, at: 1)
        view.insertSubview(tableView, at: 2)
        view.insertSubview(emptyView, at: 3)
        view.insertSubview(navBar, at: 4)
    }
    
    func addRefresh() {
        let header = RefreshGifHeader { [weak self] in
            guard let self = self else { return }
            self.list.removeAll()
            self.bannerlist.removeAll()
            self.peopleModel = IndexModel()
            self.configData()
        }
        tableView.mj_header = header
        self.tableView.mj_header?.beginRefreshing()
    }
        
    override func reSetRequest() {
        HPProgressHUD.dismiss()
        self.emptyView.isHidden = true
        self.tableView.isHidden = false
        tableView.mj_header?.beginRefreshing()
    }
    
    func configData() {
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        group.enter()
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.WBannerData { success, list in
                if success {
                    for (_, item) in list.enumerated() {
                        if item.title == "Trending" {
                            self.bannerlist = item.data
                        } else {
                            item.type = .list
                            self.list.append(item)
                        }
                    }
                } else {
                    self.showEffect = false
                }
                group.leave()
            }
        }
        group.enter()
        dispatchQueue.async {[weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.WPeopleInfo(1, 20) { success, list in
                if !success {
                    self.showEffect = false
                } else {
                    if list.count > 0 {
                        let m = IndexModel()
                        m.title = "Popular People"
                        m.type = .people
                        let mod = IndexDataModel()
                        mod.data_list = list
                        m.data.append(mod)
                        self.peopleModel = m
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main){ [weak self] in
            guard let self = self else { return }
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        self.tableView.mj_header?.endRefreshing()
        if self.list.count > 0 {
            self.list.append(self.peopleModel)
            self.emptyView.isHidden = true
            self.headView.isHidden = false
            self.tableView.isHidden = false
            self.showEffect = true
            self.bgView.isHidden = false
            self.bannerView.isHidden = false
            self.bannerView.reloadView()
        } else {
            self.emptyView.isHidden = false
            self.bgView.isHidden = true
            self.tableView.isHidden = true
            self.headView.isHidden = true
            self.showEffect = false
            self.bannerView.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    override func rightAction() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPlayVC(_ model: IndexDataListModel) {
        let vc = PlayViewController(model: model)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPeopleListVC(_ name: String) {
        let vc = PeopleListViewController()
        vc.name = name
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPeopleVC(_ model: IndexDataListModel) {
        let vc = PeopleInfoController()
        vc.pId = model.id
        vc.name = model.name
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
                    if model.type == .list {
                        let vc = ListViewController()
                        vc.name = model.title
                        vc.isMovie = indexPath.row == 0 ? true : false
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.pushPeopleListVC(model.title)
                    }
                }
            }, clickBlock: { vModel in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if model.type == .list {
                        self.pushPlayVC(vModel)
                    } else {
                        self.pushPeopleVC(vModel)
                    }
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
    -> Int { 
        if self.isDay {
            if let list = self.bannerlist.first(where: {$0.title == .today})?.data_list {
                return list.count
            }
        } else {
            if let list = self.bannerlist.first(where: {$0.title == .week})?.data_list {
                return list.count
            }
        }
        return 0
    }
    
    func jxBanner(_ banner: JXBannerType,
                  cellForItemAt index: Int,
                  cell: UICollectionViewCell)
        -> UICollectionViewCell {
            let tempCell = cell as! IndexBannerCell
            if let list = self.bannerlist.first(where: {$0.title == (self.isDay ? .today : .week)})?.data_list {
                if let model = list.indexOfSafe(index) {
                    tempCell.setModel(model)
                }
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
        if let list = self.bannerlist.first(where: {$0.title == (self.isDay ? .today : .week)})?.data_list {
            if let model = list.indexOfSafe(centerIndex) {
                self.bgView.imageV.setImage(with: model.horizontal_cover)
            }
        }
    }
    
    func jxBanner(_ banner: JXBannerType, lastCenterIndex: Int?, lastCenterCell: UICollectionViewCell?) {
    }
}

//MARK:- JXBannerDelegate
extension IndexViewController: JXBannerDelegate {
    public func jxBanner(_ banner: JXBannerType,
                         didSelectItemAt index: Int) {
        if let list = self.bannerlist.first(where: {$0.title == (self.isDay ? .today : .week)})?.data_list {
            if let model = list.indexOfSafe(index) {
                self.pushPlayVC(model)
            }
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
