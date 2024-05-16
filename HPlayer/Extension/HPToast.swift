//
//  HPToast.swift
//  HPlayer
//
//  Created by HF on 2024/2/20.
//

import UIKit

public struct HPToast {
    // 位置：上中下；传入正数向上偏移，传入负数向下偏移。
    public enum Position {
        case top(CGFloat = 0)
        case middle(CGFloat = 0)
        case bottom(CGFloat = 0)
    }
    
    // 配置项：位置、文字颜色、背景颜色、字体大小、圆角、显示时长等。
    public enum Setting {
        case position(Position)
        case textColor(UIColor)
        case backColor(UIColor)
        case fontSize(CGFloat)
        case radiusSize(CGFloat)
        case duration(TimeInterval)
    }
    
    // 默认值：未配置时为该值。
    var position: Position = .middle()
    var textColor: UIColor = .white
    var backColor: UIColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
    var fontSize: CGFloat = 16
    var radiusSize: CGFloat = 8
    var duration: TimeInterval = 2
    
    // 单例配置值：用于全局设置。
    static var setting = HPToast()
    
    // 设置全局配置值。
    static func config(_ settings: Setting ...){
        HPToast.change(obj:&HPToast.setting, settings: settings)
    }
    
    // 改变obj的设置。
    static func change(obj: inout HPToast, settings: [Setting]) {
        for setting in settings {
            switch setting {
            case let .position(position):
                obj.position = position
            case let .textColor(color):
                obj.textColor = color
            case let .backColor(color):
                obj.backColor = color
            case let .fontSize(size):
                obj.fontSize = size
            case let .radiusSize(size):
                obj.radiusSize = size
            case let .duration(interval):
                obj.duration = interval
            }
        }
    }
    
    func toast(message: String){
        if message.isEmpty {
            return
        }
        
        guard let view = self.topView() else {
            return
        }
        
        let padding: CGFloat = 32
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width - self.fontSize * 4, height: CGFloat.greatestFiniteMagnitude))
        label.text = message
        label.font = .systemFont(ofSize: self.fontSize, weight: .medium)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.textColor = self.textColor
        label.sizeToFit()
        
        let backView = UIView()
        backView.frame = CGRect(origin: label.frame.origin, size: CGSize(width: label.frame.width + padding * 2, height: label.frame.height + padding))
        backView.layer.cornerRadius = self.radiusSize
        backView.layer.masksToBounds = true
        backView.backgroundColor = self.backColor
        backView.addSubview(label)
        label.center = backView.center
        
        DispatchQueue.main.async {
            view.addSubview(backView)
            view.bringSubviewToFront(backView)
            switch self.position {
            case let .top(offset):
                backView.center = CGPoint(x: view.center.x, y: backView.frame.height + padding - offset)
            case let .middle(offset):
                backView.center = CGPoint(x: view.center.x, y: view.center.y - offset)
            case let .bottom(offset):
                backView.center = CGPoint(x: view.center.x, y: view.frame.height - backView.frame.height - padding - offset)
            }
            
            UIView.animate(withDuration: 0.5){
                backView.alpha = 1.0
            }
            
            Timer.scheduledTimer(withTimeInterval: self.duration, repeats: false) { timer in
                UIView.animate(withDuration: 0.5) {
                    backView.alpha = 0.0
                } completion: { _ in
                    backView.removeFromSuperview()
                }
                timer.invalidate()
            }
        }
    }
    
    private func topView() -> UIView? {
        if var rootVC = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = rootVC.presentedViewController {
                rootVC = presentedViewController
            }
            return rootVC.view
        }
        return nil
    }
}

public func toast(_ message: String?, _ settings: HPToast.Setting ...) {
    guard let text = message else {
        return
    }
    var t = HPToast(position: HPToast.setting.position, textColor: HPToast.setting.textColor, backColor: HPToast.setting.backColor, fontSize: HPToast.setting.fontSize, duration: HPToast.setting.duration)
    HPToast.change(obj: &t, settings: settings)
    t.toast(message: text)
}
