//
//  AVWebViewController.swift
//  HPlayer
//
//  Created by HF on 2024/2/23.
//


import UIKit
import WebKit

class AVWebViewController: VBaseViewController {
    var name: String = ""
    var urlLink: String = ""
    private lazy var webV: WKWebView = {
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
        view.addSubview(webV)
        webV.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        if let u = URL(string: self.urlLink) {
            webV.load(URLRequest(url: u))
        }
    }
}
