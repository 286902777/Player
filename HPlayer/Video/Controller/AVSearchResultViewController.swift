//
//  AVSearchResultViewController.swift
//  HPlayer
//
//  Created by HF on 2024/4/12.
//

import UIKit

class AVSearchResultViewController: VBaseViewController {
    let hostUrl = "https://suggestqueries.google.com/complete/search?client=youtube&q="
    let cellIdentifier = "AVSearchCellIdentifier"
    var searchKeys: [String] = []
    var dataList: [AVDataInfoModel] = []

    var from: AVSearchViewController.searchFrom = .home
    var addSearchKeyBlock:((_ text: String) -> Void)?
    
    private var page: Int = 1
    var key: String = "" {
        didSet {
            self.searchView.clearBtn.isHidden = self.key.count == 0
        }
    }

    let cellW = floor((kScreenWidth - 36) / 3)
    var searchView: AVHistorySearchView = AVHistorySearchView.view()
  
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.F141414
        table.bounces = false
        table.register(AVSearchCell.self, forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 16, right: 0)
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 16, right: 12)
        collectionView.register(UINib(nibName: String(describing: AVCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.searchTF.resignFirstResponder()
    }
    
    deinit {
        print("8888")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setUpUI()
        addRefresh()
        requestData()
        HPLog.tb_search_result_sh(keyword: key)
    }
    
    func setSearchBar() {
        navBar.isHidden = true
        view.addSubview(searchView)
        searchView.searchTF.delegate = self
        searchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(54)
        }
        searchView.clickCancelBlcok = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                HPLog.tb_search_result_cl(kid: "2", movie_id: "", movie_name: "")
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
        searchView.searchTF.text = self.key
    }
    
    func setUpUI() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(collectionView)
        }
    }
    
    func addRefresh() {
        let footer = RefreshAutoNormalFooter { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.loadMoreData()
        }
        collectionView.mj_footer = footer
    }
    
    func requestData() {
        self.page = 1
        self.dataList.removeAll()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.collectionView.isHidden = false
        }
        self.loadMoreData()
    }
    
    override func reSetRequest() {
        self.requestData()
    }
    
    private func loadMoreData() {
        searchView.searchTF.resignFirstResponder()
        HPProgressHUD.show()
        PlayerNetAPI.share.AVFilterInfoData(page: self.page, key: self.key, from: "\(self.from.rawValue)") { [weak self] success, list in
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
                    self.dataList.append(contentsOf: list)
                } else {
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                }
                
                if self.dataList.count == 0 {
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
    
    func searchText(_ text: String) {
        if text.count == 0 {
            return
        }
        NetManager.cancelAllRequest()
        NetManager.requestSearch(url: hostUrl + text) { [weak self] data in
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
                    self.collectionView.isHidden = true
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
}

extension AVSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
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
            self.addSearchKeyBlock?(self.key)
            self.requestData()
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

extension AVSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AVCell
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            cell.setModel(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.dataList.indexOfSafe(indexPath.item) {
            DBManager.share.updateData(model)
            HPLog.tb_search_result_cl(kid: "1", movie_id: model.id, movie_name: model.title)
            PlayerNetAPI.share.AVSearchClickInfo(model.id) { success, model in
                
            }
            PlayerManager.share.openPlayer(vc: self, id: model.id, from: .search)
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

extension AVSearchResultViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text?.removeSpace, text.count > 0 {
            self.key = text
            self.addSearchKeyBlock?(self.key)
            self.requestData()
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

extension AVSearchResultViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "suggestion"{
            if let key = attributeDict["data"]{
                self.searchKeys.append(key)
            }
        }
    }
}
