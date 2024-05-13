//
//  PlaySegView.swift
//  HPlayer
//
//  Created by HF on 2024/5/10.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXSegmentedView

class PlaySegView: UIView {
    private lazy var imgV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "w_banner_play"), for: .normal)
        return btn
    }()
    var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
        return view
    }()
    
    var titles: [String] = [] {
        didSet {
            segView.titles = titles
            segView.backgroundColor = UIColor.clear
            segView.contentEdgeInsetLeft = 12
            segView.titlesDataSource.isItemSpacingAverageEnabled = false
            segView.titlesDataSource.itemSpacing = 32
        }
    }
    let segView: PlaySegListView = PlaySegListView()
    
    var clickBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(imgV)
        self.addSubview(lineV)
        imgV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kScreenWidth)
        }
        lineV.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(segView)
        segView.snp.makeConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(lineV.snp.top)
        }
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { make in
            make.center.equalTo(self.imgV)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        self.playBtn.addTarget(self, action: #selector(clickPlayAction), for: .touchUpInside)
    }
    
    @objc func clickPlayAction() {
        self.clickBlock?()
    }
    
    func setUrl(_ url: String) {
        self.imgV.setImage(with: url)
    }
}

class PlaySegListView: JXSegmentedView {
    lazy var titlesDataSource: JXSegmentedTitleDataSource = {
        let titlesDate = JXSegmentedTitleDataSource()
        titlesDate.isTitleColorGradientEnabled = true
        titlesDate.isTitleZoomEnabled = true
        titlesDate.titleNormalColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        titlesDate.titleSelectedColor = UIColor.hexColor("#B2AAFF")
        titlesDate.titleSelectedFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        titlesDate.titleNormalFont = UIFont.systemFont(ofSize: 14)
        titlesDate.isItemSpacingAverageEnabled = true
        titlesDate.titleSelectedZoomScale = 1.14
        titlesDate.isTitleStrokeWidthEnabled = true
        return titlesDate
    }()
    
    var titles: [String]? {
        set{
            titlesDataSource.titles = newValue ?? []
        }
        get {
            (dataSource as? JXSegmentedTitleDataSource)?.titles
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    func setUI() {
        dataSource = titlesDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorCornerRadius = 1
        indicator.indicatorHeight = 4
        indicator.indicatorColor = UIColor.hexColor("#B2AAFF")
        indicators = [indicator]
        // 当总宽度没有超过最大限制的时候 设置 会有问题
        //        contentEdgeInsetLeft = 15
        //        contentEdgeInsetRight = 15
        isContentScrollViewClickTransitionAnimationEnabled = false
    }
}
