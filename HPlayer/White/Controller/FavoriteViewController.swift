//
//  FavoriteViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/9.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {
    let cellIdentifier = "FavoriteCell"

    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(UINib(nibName: String(describing: FavoriteCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kNavBarHeight, right: 0)
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var list: [IndexDataListModel] = [] {
        didSet {
            self.emptyView.isHidden = self.list.count > 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.list = DBManager.share.selectWhiteData()
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.setBackHidden(true)
        self.navBar.rightBtn.setImage(UIImage(named: "w_nav_search"), for: .normal)
        self.navBar.leftL.isHidden = false
        self.navBar.leftL.text = "Favorite"
    }
    
    override func setUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(kScreenHeight - kNavBarHeight)
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        self.emptyView.setType(.favorite)
    }
    
    override func rightAction() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoriteCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FavoriteCell
        if let model = self.list.indexOfSafe(indexPath.row) {
            cell.setModel(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.row) {
            let vc = PlayViewController(model: model)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
