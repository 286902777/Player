//
//  Array+Extension.swift
//  HPlayer
//
//  Created by HF on 2024/1/4.
//

import Foundation


extension Array {
    func indexOfSafe(_ index: Int) -> Element? {
        guard index >= 0, index < count else {
            print("count: \(count)---数组+++越界---index: \(index)")
            return nil
        }
        return self[index]
    }
}
