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
    var model: AVModel = AVModel()
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
    private var list: [PlayImageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexColor("#141414")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        self.setSortData()
    }
    
    func setSortData() {
        let count = self.model.images.count
        var i: Int = 0
        while count > i {
            if let item = self.model.images.indexOfSafe(i) {
                if item.img_mode == .horizontal {
                    let m = PlayImageModel()
                    m.urls = [item.url]
                    m.type = .Max
                    self.list.append(m)
                } else {
                    let m = PlayImageModel()
                    if let mod = self.model.images.indexOfSafe(i + 1) {
                        if mod.img_mode == .vertical {
                            m.urls = [item.url, mod.url]
                            m.type = .Double
                            i = i + 1
                            self.list.append(m)
                        } else {
                            m.urls = [item.url]
                            m.type = .Mix
                            self.list.append(m)
                        }
                    } else {
                        m.urls = [item.url]
                        m.type = .Mix
                        self.list.append(m)
                    }
                }
                i = i + 1
            }
        }
        self.tableView.reloadData()
    }
}

extension PlayImgListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = self.list.indexOfSafe(indexPath.row)
        switch m?.type {
        case .Max:
            let cell: PlayMaxImgCell = tableView.dequeueReusableCell(withIdentifier: maxcellIdentifier) as! PlayMaxImgCell
            cell.setUrl(m?.urls.first ?? "")
            return cell
        case .Double:
            let cell: PlayDoubleImgCell = tableView.dequeueReusableCell(withIdentifier: doublecellIdentifier) as! PlayDoubleImgCell
            cell.setUrl(m?.urls ?? [])
            return cell
        default:
            let cell: PlayMixImgCell = tableView.dequeueReusableCell(withIdentifier: mixcellIdentifier) as! PlayMixImgCell
            cell.setUrl(m?.urls.first ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let m = self.list.indexOfSafe(indexPath.row)
        switch m?.type {
        case .Max:
            return 16 + 260 * kScreenWidth / 375
        default:
            return 16 + 254 * kScreenWidth / 375
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
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

class PlayImageModel: BaseModel {
    enum ShowType: Int {
        case Max
        case Double
        case Mix
    }
    var urls: [String] = []
    var type: ShowType = .Max
}
