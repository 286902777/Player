//
//  String+Extension.swift
//  HPlayer
//
//  Created by HF on 2023/12/20.
//

import Foundation
import CryptoSwift
import Photos

extension String {
    var removeSpace: String {
        let text = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: text)
    }
    
    func changeToNum() -> String {
        if self.count > 1 {
            return self
        } else {
            return "0\(self)"
        }
    }
    
    /// 截取字符串
    ///
    /// - Parameter range: 截取范围
    func substring(withRange range: NSRange) -> String {
        
        return NSString(string: self).substring(with: range)
    }
    
    /// 正则替换所有字符
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - template: 替换字符
    /// - Returns: 替换后的字符串
    func replacingCharacters(pattern: String, template: String) -> String {
        do {
            let regularExpression: NSRegularExpression = try  NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: .reportProgress, range: NSMakeRange(0, self.count), withTemplate: template)
        } catch  {
            return self
        }
    }
    
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
    /// String 转换 int
    func intValue() -> Int {
        
        return NSString(string: self).integerValue
    }
    // 截取 从头到i位置，添加后缀字符
    func substringAndSuffix(to:Int , suffix : String = "...") -> String{
        if self.count > to {
            return self[0..<to] + suffix
        }
        return self
    }
    
    /// 获取字符串Size
    ///
    /// - Parameters:
    ///   - str: 待计算的字符串
    ///   - attriStr: 待计算的Attribute字符串
    ///   - font: 字体大小
    ///   - w: 宽度
    ///   - h: 高度
    /// - Returns: Size
    static func getStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize
        }
        
        if attriStr != nil {
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        
        return CGSize.zero
    }
    
    /// 获取普通字符串高度
    static func getStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }

    /// 获取普通字符串宽度
    static func getStrW(str: String, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getStrSize(str: str, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }

    func getStrSize(font: UIFont, w: CGFloat, h: CGFloat) -> CGSize {
        let strSize = self.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        
        return strSize
    }
    
    func getStrH(font: UIFont, w: CGFloat) -> CGFloat {
        getStrSize(font: font, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
    
    func getStrW(font: UIFont, h: CGFloat) -> CGFloat {
        return getStrSize(font: font, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }
    
    /// 获取Attribute字符串高度
    static func getAttributedStrH(attriStr: NSMutableAttributedString, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getStrSize(attriStr: attriStr, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }

    /// 获取Attribute字符串宽度
    static func getAttributedStrW(attriStr: NSMutableAttributedString, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getStrSize(attriStr: attriStr, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }

    /// 删除字符串前后空格
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// 删除字符串所有空格
    func deleteTrimAll() -> String {
        
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /// 验证是否是手机号码
    func isPhoneNumber() -> Bool {
        
        let pattern = "^1+[23456789]+\\d{9}"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with:self)
    }
    
    /// 验证6-20位密码
    func checkPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with:self)
    }
    
    /// 验证只能是数字字母汉字，无其他特殊字符
    func isNoOtherSuperStr() -> Bool {
        let pattern = "^[\\u4E00-\\u9FA5A-Za-z0-9]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with:self)
    }
    
    /// 计算时间戳与当前的时间差
    ///
    /// - Returns: 10分钟之内的，都显示为：刚刚
    /// 10-60分钟之间的，显示为：xx分钟前
    /// 1-24小时之间的，显示为：xx小时前
    /// 超出24小时的，显示为：mm-dd hh:mm
    func compareTime() -> String {
        
        let timeSp = TimeInterval(self)
        
        guard timeSp != nil else {
            
            return ""
        }
        
        let compareDate = Date.init(timeIntervalSince1970: timeSp!)
        
        var compareTime = compareDate.timeIntervalSinceNow
        
        compareTime = -compareTime
        
        // 获取分钟数
        var tmp = Int(compareTime / 60)
        
        var result = "刚刚"
        
        if tmp < 10 {
            // 10分钟以内，显示刚刚
            result = "刚刚"
        } else if tmp < 60 {
            // 10-60分钟之间，显示xx分钟前
            result = "\(tmp)分钟前"
        } else if Int(tmp/60) < 24 {
            // 1-24小时之间，显示xx小时前
            tmp = Int(tmp/60)
            
            result = "\(tmp)小时前"
        } else {
            // 超出24小时的，显示为：mm-dd hh:mm
            
            result = compareDate.formatString("MM-dd hh:mm")
        }
        
        return result
    }
    
    /// 时间戳转日期格式 “yyyy-MM-dd hh:mm:ss”
    func timeStampToDateString(format: String? = nil) -> String {
        
        let timeSp = TimeInterval(self)
        
        guard timeSp != nil else {
            return ""
        }
        
        let date = Date.init(timeIntervalSince1970: timeSp!)
        
        if format != nil {
            return date.formatString(format!)
        }
        
        return date.formatString("yyyy-MM-dd hh:mm:ss")
    }
    
    /// 去除空格
    func removeThinStr() -> String {
        return self.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\r", with: "")
    }
    
    func phoneStrFormat() -> String {
        
        let str = self.removeThinStr()
        
        guard str.count >= 11 else {
            
            return self
        }
        
        let first = str.substring(withRange: NSMakeRange(0, 3))
        let second = str.substring(withRange: NSMakeRange(3, 4))
        let third = str.substring(withRange: NSMakeRange(7, 4))
        
        return first + " " + second + " " + third
    }
    
    func studentIDStr() -> String {
        
        let str = self.removeThinStr()
        
        guard str.count >= 12 else {
            
            return self
        }
        
        let first = str.substring(withRange: NSMakeRange(0, 4))
        let second = str.substring(withRange: NSMakeRange(4, 4))
        let third = str.substring(withRange: NSMakeRange(8, 4))
        
        return first + " " + second + " " + third
    }
    
    //  MARK:  AES-ECB128解密
    func AESECB_Decode() -> String? {
        //decode base64
        let key = "RuRe5m69Hn+ZFObK/Hq2SQ=="

        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        if let count = data?.length {
            // 把data 转成byte数组
            for i in 0..<count {
                var temp: UInt8 = 0
                data?.getBytes(&temp, range: NSRange(location: i, length: 1))
                encrypted.append(temp)
            }
            
            // decode AES
            var decrypted: [UInt8] = []
            
            let keyData = Data(base64Encoded: key) ?? Data()
            
            do {
                decrypted = try AES(key: keyData.bytes, blockMode: ECB()).decrypt(encrypted)
            } catch {
                
            }
            
            // byte 转换成NSData
            let encoded = Data(decrypted)
            //解密结果从data转成string
            return String(bytes: encoded.bytes, encoding: .utf8)!
        } else {
            return nil
        }
    }
        
    func HPJsonToArray() -> [Any]? {
        let arr = [Any]()
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                //把NSData对象转换回JSON对象
                let json: Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
                
                return json as? [Any]
            } catch {
                return arr
            }
        } else {
            return arr
        }
    }
    
    func HPJsonToDict() -> [String : Any]? {
        if self.count > 0, let data = self.data(using: String.Encoding.utf8) {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
                return dict
            }
        }
        return nil
    }
    
    func getPhotoImage(_ completion: @escaping (UIImage?)->()) {
        if self.count == 0 {
            completion(nil)
        } else {
            let result = PHAsset.fetchAssets(
                withLocalIdentifiers: [self], options: nil)
            let asset = result[0]
            //获取保存的原图
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit,
                                                  options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                completion(image)
            })
        }
    }
}
