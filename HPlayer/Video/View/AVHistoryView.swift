//
//  AVHistoryView.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVHistoryView: UIView {
        
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.text = "History record"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "search_delete"), for: .normal)
        btn.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
        return btn
    }()
    private var list: [AVHistoryModel] = []
    
    var clickBlock: ((_ text: String) -> ())?
    var clickDeleteBlock: (() -> ())?
    var changeUIBlock: (() -> ())?
    var totalH: Int = 0
    var show: Bool = false
    
    @objc func clickDeleteAction() {
        self.clickDeleteBlock?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        self.addSubview(titleL)
        self.addSubview(deleteBtn)
        self.deleteBtn.frame = CGRect(x: kScreenWidth - 44, y: 5, width: 44, height: 44)
        self.titleL.frame = CGRect(x: 12, y: 16, width: kScreenWidth - 24, height: 22)
        self.setDataUI()
    }
    
    func setDataUI() {
        self.list.removeAll()
        let minW: CGFloat = 50
        var y: CGFloat = 56
        var x: CGFloat = 12
        let btnH: CGFloat = 36
        let itemSpace: CGFloat = 12
        let lineSpace: CGFloat = 16
        var line: Int = 1
        if let arr = UserDefaults.standard.object(forKey: HPKey.history) as? [String], arr.count > 0 {
            for i in 0 ..< arr.count {
                let model = AVHistoryModel()
                model.text = arr.indexOfSafe(i) ?? ""
                self.list.append(model)
                var width = max(minW, ceil(model.text.getStrW(font: .font(size: 14), h: 20) + 24))
                if width > kScreenWidth - 24 {
                    width = kScreenWidth - 24
                }
                
                if show {
                    if (line > 4 && x + width >= kScreenWidth - 56) || (i == arr.count - 1) {
                        let moreBtn = UIButton()
                        moreBtn.setImage(UIImage(named: "search_up"), for: .normal)
                        moreBtn.addTarget(self, action: #selector(clickUpAction), for: .touchUpInside)
                        moreBtn.frame = CGRectMake(kScreenWidth - 32, y + 8, 20, 20)
                        self.addSubview(moreBtn)
                        self.endUpdateUI(y)
                        return
                    }
                } else {
                    if line > 1, x + width >= kScreenWidth - 56 {
                        let showBtn = UIButton()
                        showBtn.setImage(UIImage(named: "search_down"), for: .normal)
                        showBtn.addTarget(self, action: #selector(clickDownAction), for: .touchUpInside)
                        showBtn.frame = CGRectMake(kScreenWidth - 32, y + 8, 20, 20)
                        self.addSubview(showBtn)
                        self.endUpdateUI(y)
                        return
                    }
                }
                
                if width + x >= kScreenWidth - 24 {
                    x = 12
                    line = line + 1
                    y = y + btnH + lineSpace
                }
               
                let btn = UIButton()
                btn.tag = i
                btn.setTitle(model.text, for: .normal)
                btn.layer.cornerRadius = 20
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitleColor(.white, for: .normal)
                btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
                let rect = CGRect(x: x, y: y, width: width, height: 36)
                btn.frame = rect
                self.addSubview(btn)
                x = x + width + itemSpace
            }
            self.endUpdateUI(y)
        }
    }
    
    func endUpdateUI(_ y: CGFloat) {
        let height = y + 36 + 24
        self.frame = CGRectMake(0, 0, kScreenWidth, height)
        self.totalH = Int(height)
    }
    
    @objc func clickDownAction() {
        self.show = true
        self.setUI()
        self.changeUIBlock?()
    }
    
    @objc func clickUpAction() {
        self.show = false
        self.setUI()
        self.changeUIBlock?()
    }
    
    @objc func clickAction(_ sender: UIButton) {
        if let model = self.list.indexOfSafe(sender.tag) {
            self.list.remove(at: sender.tag)
            self.list.insert(model, at: 0)
            UserDefaults.standard.set(self.list.map({$0.text}), forKey: HPKey.history)
            UserDefaults.standard.synchronize()
            self.setUI()
            self.clickBlock?(model.text)
        }
    }
}

class AVHistoryModel: BaseModel {
    enum historyType: Int {
        case text
        case show
        case dismiss
    }
    var text: String = ""
}
