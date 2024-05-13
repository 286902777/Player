//
//  PlayDetailsListViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXPagingView

class PlayDetailsListViewController: UIViewController {
    var model: AVModel = AVModel()
    var list: [IndexDataListModel] = []
    var refreshBlock: ((_ mod: IndexDataListModel) -> Void)?
    let cellIdentifier = "PlayDetailsCell"
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.register(UINib(nibName: String(describing: PlayDetailsCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
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
    
    func openAppshow(_ share: Bool) {
        if share {
            let url: String = "https://apps.apple.com/us/app/id\(HPKey.APPID)"
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(HPKey.APPID)?action=write-review") {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension PlayDetailsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayDetailsCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlayDetailsCell
        cell.setModel(self.model, self.list)
        cell.clickBlock = { [weak self] share in
            guard let self = self else { return }
            self.openAppshow(share)
        }
        cell.clickLikeBlock = { [weak self] like in
            guard let self = self else { return }
            let m = IndexDataListModel()
            m.id = self.model.id
            m.type = self.model.type
            m.title = self.model.title
            m.cover = self.model.cover
            m.rate = self.model.rate
            if like {
                DBManager.share.insertWhiteData(mod: m)
            } else {
                DBManager.share.deleteWhiteData(m)
            }
        }
        cell.clickItemBlock = { [weak self] m in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = PeopleInfoController()
                vc.name = m.name
                vc.pId = m.id
                vc.isRefresh = true
                vc.refreshBlock = { mod in
                    self.refreshBlock?(mod)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}
extension PlayDetailsListViewController: JXPagingViewListViewDelegate, UIScrollViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    func listView() -> UIView {
        self.view
    }
    
    func listScrollView() -> UIScrollView {
        self.tableView
    }
}
