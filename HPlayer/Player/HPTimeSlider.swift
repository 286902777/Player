//
//  HPTimeSlider.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPTimeSlider: UISlider {
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let x = rect.origin.x - 10
        let result = CGRect(x: x, y: 0, width: 30, height: 30)
        return result
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: 0, y: 13)
        let height: CGFloat = 4
        let result = CGRect(origin: point, size: CGSize(width: bounds.size.width, height: height))
        super.trackRect(forBounds: result)
        return result
    }
}
