//
//  HPPlayerLanguageFullView.swift
//  HPPlixor
//
//  Created by HF on 2024/2/21.
//

import UIKit

class HPPlayerLanguageFullView: UIView {
    @IBOutlet weak var eView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBAction func clickAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var backBlock: (()->())?
    var clickBlock: ((_ address: String)->())?
    private let cellIdentifier = "PlayerLanguageCell"
    private var list: [AVCaption] = []
    class func view() -> HPPlayerLanguageFullView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerLanguageFullView.self), owner: nil)?.first as! HPPlayerLanguageFullView
        view.eView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        view.eView.setEffectView(CGSize(width: 356 + 48, height: kScreenWidth))
        let tap = UITapGestureRecognizer(target: view, action: #selector(dismissView))
        tap.delegate = view
        view.addGestureRecognizer(tap)
        return view
    }
    
    @objc func dismissView() {
        self.backBlock?()
        self.removeFromSuperview()
    }
    func setModel(_ list: [AVCaption]) {
        self.tableView.register(UINib(nibName: String(describing: PlayerLanguageCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.list = list
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
}

extension HPPlayerLanguageFullView: UITableViewDelegate, UITableViewDataSource {
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

extension HPPlayerLanguageFullView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isDescendant(of: self.tableView) {
                return false
            }
        }
        return true
    }
}
