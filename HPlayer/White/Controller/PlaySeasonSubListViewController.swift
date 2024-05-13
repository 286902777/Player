//
//  PlaySeasonSubListViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class PlaySeasonSubListViewController: BaseViewController {

    let cellIdentifier = "PlaySeasonListCell"
    var name: String = ""
    var id: String = ""
    var ssnId: String = ""
    var list: [AVEpsModel] = []
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.estimatedRowHeight = UITableView.automaticDimension
        table.register(UINib(nibName: String(describing: PlaySeasonListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kBottomSafeHeight, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func setUI() {
        navBar.leftL.isHidden = true
        navBar.titleL.isHidden = false
        navBar.titleL.text = self.name
        view.backgroundColor = UIColor.hexColor("#141414")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.reloadData()
    }
    
    func request() {
        HPProgressHUD.show()
        PlayerNetAPI.share.AVTVEpsData(id: self.id, ssnId: self.ssnId) { [weak self] success, list in
            guard let self = self else { return }
            HPProgressHUD.dismiss()
            if success {
                self.list = list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension PlaySeasonSubListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaySeasonListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlaySeasonListCell
        if let model = self.list.indexOfSafe(indexPath.row) {
            cell.setModel(model)
            cell.clickBlock = { [weak self] in
                guard let self = self else { return }
                model.isSelect = true
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
}
