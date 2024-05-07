//
//  UIView+Extension.swift
//  HPlayer
//
//  Created by HF on 2024/1/9.
//

import UIKit

extension UIView {
    func setEffectView(_ size: CGSize, _ style: UIBlurEffect.Style = UIBlurEffect.Style.dark) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = size
        blurView.layer.masksToBounds = true
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
    }
    
    func setCorner(conrners: UIRectCorner, radius: CGFloat, _ rect: CGRect = UIScreen.main.bounds) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func setGradientLayer(colorO: UIColor, colorT: UIColor, frame: CGRect, top: Bool = false) {
        let gradient = CAGradientLayer()
        gradient.colors = [colorO.cgColor, colorT.cgColor]
        gradient.locations = [0, 1]
        gradient.frame = frame
        if top {
            gradient.startPoint = CGPoint(x: 0.50, y: 0.01)
            gradient.endPoint = CGPoint(x: 0.50, y: 1.0)
        } else {
            gradient.startPoint = CGPoint(x: 0.01, y: 0.50)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.50)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - offset: 阴影偏移量
    ///   - color: 阴影颜色
    ///   - radius: 阴影圆角
    ///   - opacity: 阴影透明度
    func setShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float = 1.0) {
        self.layer.shadowOffset = offset;
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
    
    /// 设置圆角阴影
    
    func setCornerAndShadow(corner: CGFloat, offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float = 1.0) {
        self.layer.cornerRadius = corner
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
    }
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}
