//
//  AVWebViewController.swift
//  HPlayer
//
//  Created by HF on 2024/2/20.
//


import UIKit
import WebKit

class AVWebViewController: VBaseViewController {
    var isvideo: Bool = true
    var name: String = ""
    var link: String = ""
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        self.navBar.titleL.text = name
        self.navBar.backBtn.setImage(UIImage(named: self.isvideo ? "nav_back" : "w_back"), for: .normal)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        if let url = URL(string: self.link) {
            webView.load(URLRequest(url: url))
        }
    }
}
