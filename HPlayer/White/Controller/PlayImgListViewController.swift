//
//  PlayImgListViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXPagingView

class PlayImgListViewController: UIViewController {
    let maxcellIdentifier = "PlayMaxImgCell"
    let mixcellIdentifier = "PlayMixImgCell"
    let doublecellIdentifier = "PlayDoubleImgCell"
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.register(UINib(nibName: String(describing: PlayMaxImgCell.self), bundle: nil), forCellReuseIdentifier: maxcellIdentifier)
        table.register(UINib(nibName: String(describing: PlayMixImgCell.self), bundle: nil), forCellReuseIdentifier: mixcellIdentifier)
        table.register(UINib(nibName: String(describing: PlayDoubleImgCell.self), bundle: nil), forCellReuseIdentifier: doublecellIdentifier)
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
        tableView.reloadData()
    }
}

extension PlayImgListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayMaxImgCell = tableView.dequeueReusableCell(withIdentifier: maxcellIdentifier) as! PlayMaxImgCell
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = PlaySeasonSubListViewController()
        vc.name = "Saeson 1"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PlayImgListViewController: JXPagingViewListViewDelegate, UIScrollViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    func listView() -> UIView {
        self.view
    }
    
    func listScrollView() -> UIScrollView {
        self.tableView
    }
}
