//
//  AVSearchCell.swift
//  HPlayer
//
//  Created by HF on 2024/2/26.
//

import UIKit

class AVSearchCell: UITableViewCell {
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        label.font = .font(weigth: .medium, size: 14)
        return label
    }()
    
    lazy var searchView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "search_cell")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        self.addSubview(searchView)
        self.addSubview(titleL)
        searchView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(searchView.snp.right).offset(13)
            make.right.equalTo(-12)
            make.centerY.equalTo(searchView)
        }
    }
    
    func setText(_ text: String, _ key: String) {
        self.titleL.attributedText = self.setAttributeTexts(text, [key], [UIColor.hexColor("#FFFFFF")])
    }

    /// 获取字符出现的位置信息(支持多次位置获取)
    /// - Parameter string: 原始文本
    /// - Parameter inString: 需要查找的字符
    private func rangeOfString(string:NSString,
                               andInString inString:String) -> [NSRange] {
        
        var arrRange = [NSRange]()
        var _fullText = string
        var rang:NSRange = _fullText.range(of: inString)
        
        while rang.location != NSNotFound {
            var location:Int = 0
            if arrRange.count > 0 {
                if arrRange.last!.location + arrRange.last!.length <= string.length {
                     location = arrRange.last!.location + arrRange.last!.length
                }
            }
 
            _fullText = NSString.init(string: _fullText.substring(from: rang.location + rang.length))
 
            if arrRange.count > 0 {
                  rang.location += location
            }
            arrRange.append(rang)
            
            rang = _fullText.range(of: inString)
        }
        
        return arrRange
    }
    /// 批量设置富文本
    /// - Parameter textFont: 默认文本
    /// - Parameter textColor: 默认文本颜色
    /// - Parameter changeTexts: 需要改变的文本
    /// - Parameter changFonts: 需要改变的字体
    /// - Parameter changeColors: 需要改变的颜色
    /// - Parameter isLineThrough: 是否下划线
    func setAttributeTexts(_ sText: String, _ changeTexts:[String],
                                 _ changeColors:[UIColor]) -> NSAttributedString{
        var range:NSRange?
        var dicAttr:[NSAttributedString.Key:Any]?
        let attributeString = NSMutableAttributedString.init(string: sText)
        
        //不需要改变的文本
        range = NSString.init(string: sText).range(of: String.init(sText))
        
        dicAttr = [NSAttributedString.Key.foregroundColor: UIColor.hexColor("#FFFFFF", alpha: 0.5)]
        attributeString.addAttributes(dicAttr!, range: range!)
        
        //需要改变的文本
        var index:Int = 0
        for item in changeTexts {
            //range = NSString.init(string: sText).range(of: item)
            let ranges = self.rangeOfString(string: NSString.init(string: sText.lowercased()), andInString: item.lowercased())
            for range in ranges {
                dicAttr = [
                    NSAttributedString.Key.foregroundColor:changeColors.count > index ? changeColors[index] : changeColors.first as Any,
                ]
                 if range.location + range.length <= sText.count {
                    attributeString.addAttributes(dicAttr!, range: range)
                }
            }
            
            index += 1
        }
        
        return attributeString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
