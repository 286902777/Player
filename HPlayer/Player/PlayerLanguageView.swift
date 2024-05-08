//
//  PlayerLanguageView.swift
//  HPlayer
//
//  Created by HF on 2024/4/17.
//


import UIKit

class PlayerLanguageView: UIViewController {
    private let height: CGFloat = 450

    /// 点击空白区域是否收起弹窗
    var list: [AVCaption] = []
    var clickBlock: ((_ address: String)->())?
    var backBlock: (()->())?

    var bgView: UIView = UIView()
    private let cellIdentifier = "PlayerLanguageCell"
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(UINib(nibName: String(describing: PlayerLanguageCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()
    
    private lazy var lineL:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.hexColor("#FFFFFF",alpha: 0.1)
        return label
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.bgView.transform = CGAffineTransform.identity
        }
    }
    
    private func show() {
        bgView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    private func setUpUI() {
        view.addSubview(bgView)
        view.backgroundColor = .clear
        bgView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        bgView.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height)
        bgView.setEffectView(CGSize(width: kScreenWidth, height: height), UIBlurEffect.Style.systemChromeMaterialDark)
        bgView.setCorner(conrners: [.topLeft, .topRight], radius: 24)
        bgView.addSubview(tableView)
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "nav_back"), for: .normal)
        backButton.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        let laugL = UILabel()
        laugL.textColor = .white
        laugL.font = .font(weigth: .medium, size: 20)
        laugL.text = "Switch Language"
        laugL.textAlignment = .center
        
        bgView.addSubview(backButton)
        bgView.addSubview(laugL)
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalTo(8)
            make.top.equalTo(24)
        }
        laugL.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        show()
        setUpUI()
        self.tableView.reloadData()
        for (index, model) in self.list.enumerated() {
            if model.isSelect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                }
            }
        }
    }
    
    @objc func dismissView() {
        self.backBlock?()
        self.dismiss(animated: false)
    }
    @objc func clickBackAction () {
        self.dismiss(animated: false)
    }
}
extension PlayerLanguageView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayerLanguageCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlayerLanguageCell
        if let model = self.list.indexOfSafe(indexPath.row) {
            cell.model = model
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.list.map({$0.isSelect = false})
        if let model = self.list.indexOfSafe(indexPath.row) {
            model.isSelect = true
            clickBlock?(model.local_address)
        }
        tableView.reloadData()
    }
}

extension PlayerLanguageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isDescendant(of: self.tableView) {
                return false
            }
        }
        return true
    }
}
