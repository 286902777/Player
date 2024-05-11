//
//  PlayViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import WebKit
import JXPagingView
import JXSegmentedView

class PlayViewController: BaseViewController {
    lazy var pageView: JXPagingView = {
        let pageView = JXPagingView(delegate: self)
        pageView.backgroundColor = .clear
        pageView.mainTableView.isScrollEnabled = false
        pageView.mainTableView.backgroundColor = .clear
        return pageView
    }()
    
    lazy var segementView: PlaySegView = {
        let view = PlaySegView()
        view.segView.listContainer = self.pageView.listContainerView
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
    
    func loadData() {
        if let url = URL(string: "https://www.youtube.com/embed/8C1tdXxPAWs") {
            webView.load(URLRequest(url: url))
        }
        self.segementView.titles = ["Details", "Media", "Recommendations"]
        self.segementView.segView.reloadData()
        self.pageView.reloadData()
    }
}

extension PlayViewController: JXPagingViewDelegate {
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = PlaySeasonListViewController()
//        if let model = self.topList.indexOfSafe(index) {
//            vc.list = model.data_list
//            vc.type = "\(index + 1)"
//        }
        return vc
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        Int(kScreenWidth)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        self.webView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        40
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        self.segementView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        3
    }
    
}
