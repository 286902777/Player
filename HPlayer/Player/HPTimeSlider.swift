//
//  HPTimeSlider.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPTimeSlider: UISlider {
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let frame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let x = frame.origin.x - 10
        let t = CGRect(x: x, y: 0, width: 30, height: 30)
        return t
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: 0, y: 13)
        let h: CGFloat = 4
        let r = CGRect(origin: point, size: CGSize(width: bounds.size.width, height: h))
        super.trackRect(forBounds: r)
        return r
    }
}
