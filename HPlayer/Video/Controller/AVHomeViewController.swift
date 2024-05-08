//
//  AVHomeViewController.swift
//  HPlayer
//
//  Created by HF on 2024/3/13.
//

import UIKit
import MJRefresh
import JXBanner
import JXPageControl

class AVHomeViewController: VBaseViewController {
    let cellIdentifier = "AVListCell"
    let AVBannerCellID = "AVBannerCell"
    private var dataList: [AVHomeModel] = []
    private var bannerList: [AVDataInfoModel] = []
    private var bgView: AVBannerEffectView = AVBannerEffectView()
    
    var headView: AVHomeHeadView = AVHomeHeadView.view()
    
    lazy var bannerView: JXBanner = {[weak self] in
        let banner = JXBanner(frame: CGRectMake(0, 0, kScreenWidth, kScreenWidth / 375 * 180))
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
        table.register(UINib(nibName: String(describing: AVListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInset = .zero
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var isNeedRefresh: Bool = false
    
    private var first: Bool = true
    private var showEffect: Bool = false

    private var currentTime: TimeInterval = Date().timeIntervalSince1970

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.currentTime = Date().timeIntervalSince1970
        if isNeedRefresh {
            refreshHistoryData()
        }
        if self.dataList.count == 0 {
            self.tableView.mj_header?.beginRefreshing()
        }
        if self.first == false {
            HPLog.tb_home_sh(loadsuccess: "1", errorinfo: "")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.first = false
        HPLog.tb_home_len(len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
    }
    
    func refreshHistoryData() {
        let arr = DBManager.share.selectHistoryDatas()
        if let m = self.dataList.first, m.name == "History" {
            dataList.removeFirst()
        }
        if arr.count > 0 {
            let model = AVHomeModel()
            model.name = "History"
            model.m20 = arr
            self.dataList.insert(model, at: 0)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addRefresh()
        startPushNoti()
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            HPLog.tb_home_len(len: String(Int(ceil(Date().timeIntervalSince1970 - self.currentTime))))
        }
    }

    func startPushNoti() {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate, let vid = appdelegate.pushApnsId  {
            PlayerManager.share.openPlayer(vc: self, id: vid, from: .push, animation: false)
            appdelegate.pushApnsId = nil
        }
    }
    
    func setUpUI() {
        self.navBar.isHidden = true
        view.addSubview(bgView)
        bgView.isHidden = true
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTopSafeHeight + 54 + kScreenWidth / 375 * 180)
        }
        bgView.setEffect()
        view.addSubview(headView)
        headView.clickBlock = { [weak self] type in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if type == .vip {
                    self.tabBarController?.selectedIndex = 2
                    HPLog.tb_vip_sh(source: "2")
                    HPLog.tb_home_cl(kid: "6", c_id: "", c_name: "", ctype: "", secname: "", secid: "")
                } else {
                    self.openSearch()
                }
            }
        }
        headView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(54)
        }
        
        view.addSubview(tableView)
        tableView.tableHeaderView = self.bannerView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(tableView)
        }
        self.emptyView.setType()
    }
    
    func addRefresh() {
        let header = RefreshGifHeader { [weak self] in
            guard let self = self else { return }
            self.configData()
        }
        tableView.mj_header = header
        if HPConfig.share.avRequest == false {
            HPConfig.share.avRequest = true
            tableView.mj_header?.beginRefreshing()
        } else {
            if HPConfig.share.cfgDataList.count > 0, HPConfig.share.cfgBannerList.count > 0 {
                self.dataList = HPConfig.share.cfgDataList
                self.bannerList =  HPConfig.share.cfgBannerList
                self.isNeedRefresh = true
                self.refreshUI()
            } else {
                NetManager.cancelAllRequest()
                self.tableView.mj_header?.beginRefreshing()
            }
        }
    }
    
    func getDBData() {
        for item in self.dataList {
           let _ = item.m20.map{$0.type = item.type}
        }
        let arr = DBManager.share.selectHistoryDatas()
        if arr.count > 0 {
            let model = AVHomeModel()
            model.name = "History"
            model.m20 = arr
            self.dataList.insert(model, at: 0)
        }
    }
    
    override func reSetRequest() {
        HPProgressHUD.dismiss()
        tableView.mj_header?.beginRefreshing()
    }
    
    func configData() {
        self.isNeedRefresh = false
        self.dataList.removeAll()
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
                        self.dataList = list
                        self.getDBData()
                    }
                    self.isNeedRefresh = true
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
            if self.bannerList.count > 0, self.dataList.count > 0 {
                self.emptyView.isHidden = true
                self.bannerView.isHidden = false
                self.tableView.isHidden = false
                self.bannerView.reloadView()
            } else {
                self.emptyView.isHidden = false
                self.bgView.isHidden = true
                self.tableView.isHidden = true
                self.bannerView.isHidden = true
            }
            self.tableView.reloadData()
            if self.bannerList.count > 0 {
                self.showEffect = true
                self.bgView.isHidden = false
            }
        }
    }
    
    @objc func openSearch() {
        let vc = AVSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.from = .home
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AVHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AVListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AVListCell
        if let model = self.dataList.indexOfSafe(indexPath.row) {
            cell.setModel(model: model, clickMoreBlock: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                        if model.name == "History", model.id.isEmpty {
                            HPLog.tb_home_cl(kid: "8", c_id: "", c_name: "", ctype: "", secname: model.name, secid: "")
                            let vc = AVHistoryViewListController()
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            HPLog.tb_home_cl(kid: "4", c_id: "", c_name: "", ctype: "", secname: model.name, secid: model.id)
                            let vc = AVListViewController()
                            vc.name = model.name
                            vc.listId = model.id
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                }
            }, clickBlock: { movieModel in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    DBManager.share.updateData(movieModel)
                    if model.name == "History" && model.id.isEmpty {
                        HPLog.tb_home_cl(kid: "3", c_id: movieModel.id, c_name: movieModel.title, ctype: movieModel.type == 1 ? "1" : "2", secname: model.name, secid: "")
                        PlayerManager.share.openPlayer(vc: self, id: movieModel.id, from: .history)
                    } else {
                        HPLog.tb_home_cl(kid: "1", c_id: movieModel.id, c_name: movieModel.title, ctype: movieModel.type == 1 ? "1" : "2", secname: model.name, secid: model.id)
                        PlayerManager.share.openPlayer(vc: self, id: movieModel.id, from: .index)
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
        self.dataList.count
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
extension AVHomeViewController: JXBannerDataSource {
    
    func jxBanner(_ banner: JXBannerType)
        -> (JXBannerCellRegister) {
            return JXBannerCellRegister(type: AVBannerCell.self,
                                        reuseIdentifier: AVBannerCellID)
    }
    
    func jxBanner(numberOfItems banner: JXBannerType)
    -> Int { return self.bannerList.count }
    
    func jxBanner(_ banner: JXBannerType,
                  cellForItemAt index: Int,
                  cell: UICollectionViewCell)
        -> UICollectionViewCell {
            let tempCell = cell as! AVBannerCell
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
            let H = kScreenWidth / 375 * 180
            return layoutParams
                .layoutType(JXBannerTransformLinear())
                .itemSize(CGSize(width: kScreenWidth - 56, height: H))
                .itemSpacing(16)
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
                maker.bottom.equalTo(coverView.snp.bottom).offset(-10)
                maker.height.equalTo(3)
            }
        }
        return builder
    }
    
    func jxBanner(_ banner: JXBannerType, centerIndex: Int, centerCell: UICollectionViewCell) {
        let tempCell = centerCell as! AVBannerCell
        tempCell.playView.isHidden = false
        tempCell.topMView.isHidden = true
        if let model = self.bannerList.indexOfSafe(centerIndex) {
            self.bgView.imageV.setImage(with: model.horizontal_cover)
        }
    }
    
    func jxBanner(_ banner: JXBannerType, lastCenterIndex: Int?, lastCenterCell: UICollectionViewCell?) {
        if let tempCell = lastCenterCell, let cell = tempCell as? AVBannerCell {
            cell.playView.isHidden = true
            cell.topMView.isHidden = false
        }
    }
}

//MARK:- JXBannerDelegate
extension AVHomeViewController: JXBannerDelegate {
    public func jxBanner(_ banner: JXBannerType,
                         didSelectItemAt index: Int) {
        if let model = self.bannerList.indexOfSafe(index) {
            DBManager.share.updateData(model)
            HPLog.tb_home_cl(kid: "9", c_id: model.id, c_name: model.title, ctype: model.type == 1 ? "1" : "2", secname: "banner", secid: "")
            PlayerManager.share.openPlayer(vc: self, id: model.id, from: .banner)
        }
    }
    
    func jxBanner(_ banner: JXBannerType, coverView: UIView) {

    }
    
    func jxBanner(_ banner: JXBannerType, center index: Int) {

    }
}

extension AVHomeViewController: UIScrollViewDelegate {
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
