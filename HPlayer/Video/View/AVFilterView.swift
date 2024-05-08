//
//  AVFilterView.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVFilterView: UIView {
    enum FilterType: Int {
        case type = 0
        case genre
        case year
        case country
    }
    
    let cellIdentifier = "AVFilterListCellIdentifier"
    typealias clickBlock = (_ index: FilterType, _ name: String, _ index: Int) -> Void
    var clickHandle : clickBlock?

    private var dataList: [[AVFilterCategoryInfoModel]] = []
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(UINib(nibName: String(describing: AVFilterListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
    }
    
    func setupSubViews() {
        self.backgroundColor = .clear
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
     
    func setModel(_ arr: [[AVFilterCategoryInfoModel]], clickBlock: clickBlock?) {
        self.clickHandle = clickBlock
        self.dataList = arr
        if dataList.count > 0 {
            self.tableView.reloadData()
        }
    }
}

extension AVFilterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AVFilterListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AVFilterListCell
        if let model = self.dataList.indexOfSafe(indexPath.row) {
            cell.setModel(model, clickBlock: { [weak self] title, idx in
                guard let self = self else { return }
                self.clickHandle?(FilterType(rawValue: indexPath.row) ?? .type,  idx == 0 ? "all" : title, idx)
            })
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

}
