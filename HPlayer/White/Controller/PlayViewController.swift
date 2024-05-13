//
//  PlayViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

class PlayViewController: BaseViewController {
    lazy var pageView: JXPagingView = {
        let pageView = JXPagingView(delegate: self)
        pageView.backgroundColor = .clear
        pageView.mainTableView.backgroundColor = .clear
        return pageView
    }()
    
    lazy var segementView: PlaySegView = {
        let view = PlaySegView()
        view.segView.listContainer = self.pageView.listContainerView
        return view
    }()
    
    private var isMovie: Bool = true
    private var dataModel: AVModel = AVModel()
    private var infoModel: AVMoreModel = AVMoreModel()
    private var ssnList: [AVInfoSsnlistModel] = []
    
    private var model: IndexDataListModel = IndexDataListModel()
    
    init(model: IndexDataListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestResouce()
    }
    
    deinit {
       print("PlayViewController deinit")
    }
    
    override func reSetRequest() {
        requestResouce()
    }
    
    override func setUI() {
        navBar.backBtn.setImage(UIImage(named: "w_play_back"), for: .normal)
        navBar.backgroundColor = .clear
        
        view.addSubview(pageView)
        
        pageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(pageView)
        }
        self.emptyView.setType()
        view.insertSubview(backView, at: 0)
        view.insertSubview(pageView, at: 1)
        view.insertSubview(emptyView, at: 2)
        view.insertSubview(navBar, at: 3)
    }
    
    func requestResouce() {
        HPProgressHUD.show()
        var requestResult: Bool = true
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        group.enter()
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVInfoData(isMovie: self.model.type == 1 ? true : false, id: self.model.id) { success, model in
                if success {
                    self.dataModel = model
                } else {
                    requestResult = false
                }
                group.leave()
            }
        }
        group.enter()
        dispatchQueue.async {[weak self] in
            guard let self = self else { return }
            PlayerNetAPI.share.AVMoreInfoData(isMovie: self.model.type == 1 ? true : false, id: self.model.id) { success, model in
                if success {
                    self.infoModel = model
                } else {
                    requestResult = false
                }
                group.leave()
            }
        }
        if self.model.type == 2 {
            group.enter()
            dispatchQueue.async {[weak self] in
                guard let self = self else { return }
                PlayerNetAPI.share.AVTVSsnData(id: self.model.id) { success, list in
                    if success {
                        self.ssnList = list
                    } else {
                        requestResult = false
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: dispatchQueue){ [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                HPProgressHUD.dismiss()
                if requestResult == false {
                    self.pageView.isHidden = true
                    self.emptyView.isHidden = false
                } else {
                    self.pageView.isHidden = false
                    self.emptyView.isHidden = true
                    if self.model.type == 1 {
                        self.segementView.titles = ["Details", "Media", "Recommendations"]
                    } else {
                        self.segementView.titles = ["Details", "Season", "Media", "Recommendations"]
                    }
                    self.segementView.setUrl(self.dataModel.cover)
                }
                self.segementView.segView.selectItemAt(index: 0)
                self.segementView.segView.reloadData()
                self.segementView.clickBlock = {
                    DispatchQueue.main.async {
                        let vc = AVWebViewController()
                        vc.name = self.model.title
                        vc.isvideo = false
                        vc.link = self.dataModel.trailer
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                self.pageView.reloadData()
            }
        }
    }
}

extension PlayViewController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        0
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        UIView()
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        switch index {
        case 0:
            let vc = PlayDetailsListViewController()
            vc.model = self.dataModel
            vc.list = self.infoModel.cast
            vc.refreshBlock = {[weak self] mod in
                guard let self = self else { return }
                self.model = mod
                self.requestResouce()
            }
            return vc
        case 1:
            if self.model.type == 1 {
                let vc = PlayImgListViewController()
                vc.model = self.dataModel
                return vc
            } else {
                let vc = PlaySeasonListViewController()
                vc.id = self.model.id
                vc.list = self.ssnList
                return vc
            }
        case 2:
            if self.model.type == 1 {
                let vc = PlayListViewController()
                if let list = self.infoModel.related_list.first?.data_list {
                    vc.list = list
                }
                vc.refreshBlock = { [weak self] mod in
                    guard let self = self else { return }
                    self.model = mod
                    self.requestResouce()
                }
                return vc
            } else {
                let vc = PlayImgListViewController()
                vc.model = self.dataModel
                return vc
            }
        default:
            let vc = PlayListViewController()
            if let list = self.infoModel.related_list.first?.data_list {
                vc.list = list
            }
            vc.refreshBlock = { [weak self] mod in
                guard let self = self else { return }
                self.model = mod
                self.requestResouce()
            }
            return vc
        }
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        Int(40 + kScreenWidth)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        self.segementView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        self.segementView.titles.count
    }
}
