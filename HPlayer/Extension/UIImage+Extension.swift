//
//  UIImage+Extension.swift
//  HPlayer
//
//  Created by HF on 2023/12/19.
//

import Foundation
import UIKit
import Photos
import Kingfisher

extension UIImage {
    func saveImage(_ complete: @escaping (String?)->()){
        var saveUrl:String?
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: self)
            let asset = result.placeholderForCreatedAsset
            //保存标志符
            saveUrl = asset?.localIdentifier
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                print("保存成功!")
                complete(saveUrl)
            } else{
                print("保存失败：", error!.localizedDescription)
            }
        }
    }
}

extension UIImageView {
    typealias CompletionHandler = (_ image: UIImage?)->()
    func setImage(with url: String?, placeholder: String = "placeholder", complete: CompletionHandler? = nil) {
        let placeImage = UIImage(named: placeholder)

        var imageUrl: String? = url
        
        // 解决url已被后台urlEncode，先将url Decode后，再Encode
        if let decodeUrl = url?.removingPercentEncoding {
            imageUrl = decodeUrl
        }
        
        guard let urlString = imageUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            self.image = placeImage
            return
        }
        
        let imgUrl = URL(string: urlString)
        self.kf.setImage(with: imgUrl, placeholder: placeImage, options: [.cacheSerializer(DefaultCacheSerializer.default)], progressBlock: nil) { (result) in
            switch result {
            case let .success(imgResult):
                complete?(imgResult.image.kf.normalized)
            case let .failure(error):
                print(error)
                break
            }
        }
    }
}

extension UIColor {
    /// 16进制字符串转颜色
    /// - Parameters:
    ///   - hexString: 16进制色值字符串, "FFFFFF"
    ///   - alpha: 透明度
    /// - Returns: 颜色
    static func hexColor(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = hexString
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        
        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }

    static var BGColor: UIColor {
        return UIColor.hexColor("#FAFAFA")
    }
    
    static var F141414: UIColor {
        return UIColor.hexColor("#141414")
    }
    
    static var F14141450: UIColor {
        return UIColor.hexColor("#141414", alpha: 0.5)
    }

    static var F888888: UIColor {
        return UIColor.hexColor("#888888")
    }
    
    static var FF3EEFF: UIColor {
        return UIColor.hexColor("#F3EEFF")
    }

    static var F7465EA05: UIColor {
        return UIColor.hexColor("#7465EA", alpha: 0.05)
    }

}
