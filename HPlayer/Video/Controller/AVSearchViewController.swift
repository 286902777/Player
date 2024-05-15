//
//  AVSearchViewController.swift
//  HPlayer
//
//  Created by HF on 2024/3/17.
//

import UIKit
import JXPagingView
import JXSegmentedView

class AVSearchViewController: VBaseViewController {
    enum searchFrom: Int {
        case home = 1
        case explore
        case list
        case cancel
    }
    let cellIdentifier = "AVSearchCellIdentifier"
    var searchKeys: [String] = []
    var dataList: [AVDataInfoModel] = []
    var topList: [AVSearchTopDataModel] = []

    private var page: Int = 1
    private var key: String = "" {
        didSet {
            self.searchView.searchTF.text = self.key
            self.searchView.clearBtn.isHidden = self.key.count == 0
        }
    }
    var from: searchFrom = .home
    var cancelFrom: searchFrom = .home

    let cellW = floor((kScreenWidth - 36) / 3)
    
    let historyView: AVHistoryView = AVHistoryView()
    var searchView: AVHistorySearchView = AVHistorySearchView.view()
    
    lazy var pageView: JXPagingView = {
        let pageView = JXPagingView(delegate: self)
        pageView.backgroundColor = .clear
        pageView.isHidden = true
        pageView.mainTableView.backgroundColor = .clear
        return pageView
    }()
    
    lazy var segementView: AVSearchTopView = {
        let view = AVSearchTopView()
        view.segView.listContainer = self.pageView.listContainerView
        return view
    }()
    
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
    
    var task: URLSessionDataTask?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if self.cancelFrom == .cancel {
            HPLog.tb_search_sh(statuses: "1", source: "\(self.cancelFrom.rawValue)")
            self.cancelFrom = .home
        } else {
            HPLog.tb_search_sh(statuses: "1", source: "\(self.from.rawValue)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchView.searchTF.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setUpUI()
        requestListData()
        HPLog.tb_home_cl(kid: "2", c_id: "", c_name: "", ctype: "", secname: "", secid: "")
    }
    
    func setSearchBar() {
        navBar.isHidden = true
        view.addSubview(searchView)
        searchView.searchTF.delegate = self
        searchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(54)
        }
        searchView.clickCancelBlcok = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                HPLog.tb_search_cl(kid: "3", movie_id: "", movie_name: "")
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
    
    func setUpUI() {
        self.configHistoryView()
        view.addSubview(pageView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        pageView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(tableView)
        }
        self.emptyView.setType()

    }
    override func reSetRequest() {
        self.topList.removeAll()
        self.requestListData()
    }
    
    func requestListData() {
        HPProgressHUD.show()
        PlayerNetAPI.share.AVSearchTopData(from: "\(self.from.rawValue)", {[weak self] success, list in
            guard let self = self else { return }
            HPProgressHUD.dismiss()
            if success {
                self.emptyView.isHidden = true
                self.topList.append(contentsOf: list)
                self.segementView.isHidden = false
                if self.topList.count == 0 {
                    self.pageView.isHidden = true
                }
            } else {
                self.emptyView.isHidden = false
                self.segementView.isHidden = true
                self.historyView.isHidden = true
            }
           
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = true
                self.pageView.isHidden = false
                self.segementView.titles = self.topList.map({$0.title})
                self.segementView.segView.reloadData()
                self.pageView.reloadData()
            }
        })
    }
   
    private func requestData() {
        if self.key.count == 0 {
            return
        }
        HPLog.tb_search_cl(kid: "4", movie_id: "", movie_name: "")
        self.setHistoryText(self.key)
        self.pushResultVC()
    }
    
    func pushResultVC() {
        let vc = AVSearchResultViewController()
        vc.key = self.key
        self.cancelFrom = .cancel
        vc.addSearchKeyBlock = {[weak self] text in
            guard let self = self else { return }
            self.setHistoryText(text)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchText(_ text: String) {
        if text.count == 0 {
            return
        }
        self.searchKeys.removeAll()
        let url: String = HPKey.gHostUrl + text
        var request: URLRequest = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        self.task?.cancel()
        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            if let result = response as? HTTPURLResponse, result.statusCode == 200, let d = data {
                if let arr = self.getSearchData(d) {
                    for i in arr {
                        if let sub = i as? Array<Any> {
                            for s in sub {
                                if s is String {
                                    self.searchKeys.append(s as? String ?? "")
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
                        self.emptyView.isHidden = true
                        self.segementView.isHidden = true
                        self.historyView.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
                return
            }
        })
        self.task?.resume()
    }
    
    func getSearchData(_ data: Data) -> Array<Any>? {
        do {
            let arr = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return arr as? Array<Any>
        } catch {
            print("error")
        }
        return nil
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
    
    //MARK: - histroy
    func configHistoryView() {
        if let arr = UserDefaults.standard.object(forKey: HPKey.history) as? [String], arr.count > 0 {
            view.addSubview(historyView)
            historyView.clickBlock = { [weak self] text in
                guard let self = self else { return }
                self.key = text
                HPLog.tb_search_cl(kid: "2", movie_id: "", movie_name: "")
                self.pushResultVC()
            }
            historyView.clickDeleteBlock = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let vc = AVAlertController.init("Delete", "Do you want to delete the history record?")
                    vc.clickBlock = {
                        UserDefaults.standard.set([], forKey: HPKey.history)
                        UserDefaults.standard.synchronize()
                        self.historyView.totalH = 0
                        self.historyView.isHidden = true
                        self.pageView.reloadData()
                    }
                    self.present(vc, animated: false)
                }
            }
            self.historyView.changeUIBlock = {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.pageView.reloadData()
                }
            }
            self.historyView.isHidden = false
        } else {
            self.historyView.isHidden = true
        }
        self.pageView.reloadData()
    }
    
    func setHistoryText(_ text: String) {
        if let arr = UserDefaults.standard.object(forKey: HPKey.history) as? [String] {
            var list = arr.filter({$0 != text})
            list.insert(text, at: 0)
            UserDefaults.standard.set(list, forKey: HPKey.history)
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set([text], forKey: HPKey.history)
            UserDefaults.standard.synchronize()
        }
        self.historyView.isHidden = false
        self.historyView.setUI()
        self.configHistoryView()
        self.pageView.reloadData()
    }
}

extension AVSearchViewController: UITableViewDelegate, UITableViewDataSource {
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

extension AVSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text?.removeSpace, text.count > 0 {
            self.key = text
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

extension AVSearchViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "suggestion"{
            if let key = attributeDict["data"]{
                self.searchKeys.append(key)
            }
        }
    }
}

extension AVSearchViewController: JXPagingViewDelegate {
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = AVSearchListViewController()
        if let model = self.topList.indexOfSafe(index) {
            vc.list = model.data_list
            vc.type = "\(index + 1)"
        }
        return vc
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        self.historyView.totalH
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        self.historyView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        88
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        self.segementView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        self.topList.count
    }
    
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

