//
//  AVSearchTopView.swift
//  HPlayer
//
//  Created by HF on 2024/4/11.
//

import UIKit
import JXSegmentedView

class AVSearchTopView: UIView {
    var titleL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Top Search"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
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
            segView.titlesDataSource.itemSpacing = 24
        }
    }
    let segView: AVSearchSegView = AVSearchSegView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(12)
        }
        self.addSubview(segView)
        segView.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(28)
            make.bottom.equalTo(-12)
        }
        self.addSubview(lineV)
        lineV.snp.makeConstraints { make in
            make.top.equalTo(segView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

class AVSearchSegView: JXSegmentedView {
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
        indicator.indicatorWidth = 12
        indicator.indicatorCornerRadius = 2
        indicator.indicatorHeight = 4
        indicator.indicatorColor = UIColor.hexColor("#B2AAFF")
        indicators = [indicator]
        // 当总宽度没有超过最大限制的时候 设置 会有问题
//        contentEdgeInsetLeft = 15
//        contentEdgeInsetRight = 15
        isContentScrollViewClickTransitionAnimationEnabled = false
    }
}
