//
//  PlaySeasonListViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXPagingView

class PlaySeasonListViewController: UIViewController {
    var list: [AVInfoSsnlistModel] = []
    var id: String = ""
    
    let cellIdentifier = "PlaySeasonCell"
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.register(UINib(nibName: String(describing: PlaySeasonCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kBottomSafeHeight, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexColor("#141414")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.list.first?.isSelect = true
        tableView.reloadData()
    }
}

extension PlaySeasonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaySeasonCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlaySeasonCell
        if let model = self.list.indexOfSafe(indexPath.row) {
            cell.setModel(model)
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.list.map({$0.isSelect = false})
        if let model = self.list.indexOfSafe(indexPath.row) {
            model.isSelect = true
            self.tableView.reloadData()
            let vc = PlaySeasonSubListViewController()
            vc.name = model.title
            vc.id = self.id
            vc.ssnId = model.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension PlaySeasonListViewController: JXPagingViewListViewDelegate, UIScrollViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    func listView() -> UIView {
        self.view
    }
    
    func listScrollView() -> UIScrollView {
        self.tableView
    }
}
