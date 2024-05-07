//
//  AVHistoryViewListController.swift
//  TBPlixor
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVHistoryViewListController: VBaseViewController {
    let cellW = floor((kScreenWidth - 36) / 3)
    var listId: String = ""
    var dataList: [AVDataInfoModel] = []
    private var page: Int = 1
    private var isSelect: Bool = false
    let cellIdentifier = "AVHistoryCell"
 
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.bounces = false
        table.register(UINib(nibName: String(describing: AVHistoryCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    private var botView: AVHistoryBottomView = AVHistoryBottomView.view()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setUpUI() {
        navBar.titleL.text = "Recently Played"
        navBar.rightBtn.setImage(UIImage(named: "his_edit"), for: .normal)
        view.addSubview(botView)
        view.addSubview(tableView)
        botView.frame = CGRect(x: 0, y: kScreenHeight, width: 0, height: 0)
        self.botView.isHidden = true
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(botView.snp.top)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    override func clickRightAction() {
        self.isSelect = !self.isSelect
        if self.isSelect {
            navBar.rightBtn.setImage(UIImage(named: "nav_sure"), for: .normal)
            self.botView.isHidden = false
            self.tableView.reloadData()
            botView.frame = CGRect(x: 0, y: kScreenHeight - 98 - kBottomSafeHeight, width: kScreenWidth, height: 98 + kBottomSafeHeight)
            self.botView.show()
            self.botView.clickSelectBlock = { [weak self] select in
                guard let self = self else { return }
                let _ = self.dataList.map({$0.isSelect = select})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.botView.clickBlock = { [weak self] index in
                guard let self = self else { return }
                if index == 1 {
                    let _ = self.dataList.map({$0.isSelect = false})
                    self.isSelect = false
                    DispatchQueue.main.async {
                        self.navBar.rightBtn.setImage(UIImage(named: "his_edit"), for: .normal)
                        self.botView.frame = CGRect(x: 0, y: kScreenHeight, width: 0, height: 0)
                        self.botView.isHidden = true
                        self.tableView.reloadData()
                    }
                } else {
                    let selectArr = self.dataList.filter({$0.isSelect == true})
                    for (_, m) in selectArr.enumerated() {
                        let model = AVModel()
                        model.title = m.title
                        model.id = m.id
                        DBManager.share.deleteData(model)
                    }
                    self.dataList = self.dataList.filter({$0.isSelect == false})
                    DispatchQueue.main.async {
                        toast("Delete success!")
                        self.tableView.reloadData()
                        if self.dataList.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            navBar.rightBtn.setImage(UIImage(named: "nav_sure"), for: .normal)
            self.botView.frame = CGRect(x: 0, y: kScreenHeight, width: 0, height: 0)
            self.botView.isHidden = true
            let _ = self.dataList.map({$0.isSelect = false})
            self.tableView.reloadData()
        }
    }
    
    func initData() {
        self.dataList = DBManager.share.selectHistoryDatas()
        self.tableView.reloadData()
    }
}

extension AVHistoryViewListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AVHistoryCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AVHistoryCell
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            cell.setModel(isShow: self.isSelect, model: model)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        144
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            if self.isSelect {
                model.isSelect = !model.isSelect
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    let selectArr = self.dataList.filter({$0.isSelect == false})
                    if selectArr.count == 0 {
                        self.botView.selectBtn.isSelected = true
                    } else {
                        self.botView.selectBtn.isSelected = false
                    }
                }
            } else {
                DBManager.share.updateData(model)
                PlayerManager.share.openPlayer(vc: self, id: model.id, from: .historyList)
            }
        }
    }
}
