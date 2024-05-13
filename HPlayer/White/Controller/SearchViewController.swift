//
//  SearchViewController.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    let gHostUrl = "https://suggestqueries.google.com/complete/search?client=youtube&q="
    let cellW = floor((kScreenWidth - 36) / 3)
    var list: [AVDataInfoModel] = []
    var searchView: IndexSearchView = IndexSearchView.view()
    var searchKeys: [String] = []
    var cellIdentifier: String = "AVSearchCellID"
    var IndexCellIdentifier: String = "IndexCellIdentifier"
    var key: String = "" {
        didSet {
            self.searchView.clearBtn.isHidden = self.key.count == 0
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.register(AVSearchCell.self, forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kBottomSafeHeight, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.isHidden = true
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: kBottomSafeHeight, right: 12)
        collectionView.register(UINib(nibName: String(describing: IndexCell.self), bundle: nil), forCellWithReuseIdentifier: IndexCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    private var page: Int = 1
    let recordView: IndexSearchRecordView = IndexSearchRecordView.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordView.refreshData()
        NotificationCenter.default.addObserver(forName: HPKey.Noti_Like, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setUI() {
        navBar.isHidden = true
        setSearchBar()
        
        view.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(22)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(22)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(collectionView)
        }
        self.emptyView.setType(.content)
        
        recordView.clickBlock = {[weak self] text in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.key = text
                self.showResult()
            }
        }
        recordView.clickDeleteBlock = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = SearchAlertController.init("Delete", "Do you want to delete the history record?")
                vc.clickBlock = {
                    UserDefaults.standard.set([], forKey: HPKey.searchRecord)
                    UserDefaults.standard.synchronize()
                    self.recordView.refreshData()
                }
                self.present(vc, animated: false)
            }
        }
    }
    
    func setSearchBar() {
        view.addSubview(searchView)
        searchView.searchTF.delegate = self
        searchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(54)
        }
        searchView.clickCancelBlcok = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        }
        searchView.clickClearBlcok = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.searchView.searchTF.text = ""
                self.key = ""
                self.tableView.isHidden = true
            }
        }
    }
    
    func searchText(_ text: String) {
        if text.count == 0 {
            return
        }
        NetManager.requestSearch(url: gHostUrl + text) { [weak self] data in
            guard let self = self else { return }
            self.searchKeys.removeAll()
            if let arr = self.getSearchData(data) {
                for i in arr {
                    if let sub = i as? Array<Any> {
                        for s in sub {
                            if let keys = s as? Array<Any> {
                                self.searchKeys.append(keys.first as? String ?? "")
                            }
                        }
                    } else if i is String {
                        self.searchKeys.append(i as? String ?? "")
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.searchKeys.count > 0 {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getSearchData(_ data: String) -> Array<Any>? {
        guard let start = data.range(of: "(") else {
            return nil
        }

        let stratRange = NSRange(start, in: data)
        let str = data.substring(withRange: NSRange(location: stratRange.location + 1, length: data.count - stratRange.location - 2))
        print(str)
        do {
            if let d = str.data(using: .utf8) {
                let arr = try JSONSerialization.jsonObject(with: d, options: .mutableContainers)
                return arr as? Array<Any>
            }
        } catch {
            print("error")
        }
        return nil
    }
    
    func setRecordText(_ text: String) {
        if let arr = UserDefaults.standard.object(forKey: HPKey.searchRecord) as? [String] {
            var list = arr.filter({$0 != text})
            list.insert(text, at: 0)
            UserDefaults.standard.set(list, forKey: HPKey.searchRecord)
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set([text], forKey: HPKey.searchRecord)
            UserDefaults.standard.synchronize()
        }
        self.recordView.isHidden = false
        self.emptyView.isHidden = true
        self.recordView.refreshData()
    }
    
    override func reSetRequest() {
        self.showResult()
    }
    
    private func loadMoreData() {
        searchView.searchTF.resignFirstResponder()
        HPProgressHUD.show()
        PlayerNetAPI.share.AVFilterInfoData(page: self.page, key: self.key) { [weak self] success, list in
            guard let self = self else { return }
            HPProgressHUD.dismiss()
            if !success {
                self.collectionView.mj_footer?.isHidden = true
                self.emptyView.setType()
                self.emptyView.isHidden = false
            } else {
                if list.count > 0 {
                    self.collectionView.mj_footer?.isHidden = false
                    self.emptyView.isHidden = true
                    self.list.append(contentsOf: list)
                } else {
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                }
                
                if self.list.count == 0 {
                    self.collectionView.mj_footer?.isHidden = true
                    self.emptyView.setType(.content)
                    self.emptyView.isHidden = false
                }
            }
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
           
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    func showResult() {
        self.page = 1
        self.list.removeAll()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.collectionView.isHidden = false
        }
        self.loadMoreData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AVSearchCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AVSearchCell
        if let t = self.searchKeys.indexOfSafe(indexPath.row) {
            cell.setText(t, self.key)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = self.searchKeys.indexOfSafe(indexPath.row)?.removeSpace {
            self.key = text
            self.searchView.searchTF.text = self.key
            self.showResult()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchKeys.count
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexCellIdentifier, for: indexPath) as! IndexCell
        if let model = self.list.indexOfSafe(indexPath.item) {
            cell.setPlayModel(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.list.indexOfSafe(indexPath.item) {
            let mod = IndexDataListModel()
            mod.id = model.id
            mod.type = model.type
            mod.title = model.title
            mod.cover = model.cover
            mod.rate = model.rate
            let vc = PlayViewController(model: mod)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellW, height: cellW * 3 / 2 + 18)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text?.removeSpace, text.count > 0 {
            self.key = text
            self.showResult()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text?.removeSpace {
            self.key = text
            searchText(text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text?.removeSpace {
            self.key = text
            searchText(text)
        }
    }
}

extension SearchViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "suggestion"{
            if let key = attributeDict["data"]{
                self.searchKeys.append(key)
            }
        }
    }
}
