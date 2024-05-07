//
//  Date+Extension.swift
//  HPlayer
//
//  Created by HF on 2024/1/2.
//

import Foundation

extension Date {
    
    /// 日期转化为日期字符串
    /// EEEE:表示星期几(Monday),使用1-3个字母表示周几的缩写
    /// MMMM:月份的全写(October),使用1-3个字母表示月份的缩写
    /// dd:表示日期,使用一个字母表示没有前导0
    /// YYYY:四个数字的年份(2016)
    /// HH:两个数字表示的小时(02或21)
    /// mm:两个数字的分钟 (02或54)
    /// ss:两个数字的秒
    /// zzz:三个字母表示的时区
    /// - Returns: 日期字符串
    func formatString(_ format: String = "MMM dd, yyyy") -> String {
        
        let formater: DateFormatter = DateFormatter()
        
        formater.dateFormat = format
        
        return formater.string(from: self)
    }
    
    func formatMonthString(_ format: String = "MMM") -> String {
        
        let formater: DateFormatter = DateFormatter()
        
        formater.dateFormat = format
        
        return formater.string(from: self)
    }
    
    func formatDayString(_ format: String = "dd") -> String {
        
        let formater: DateFormatter = DateFormatter()
        
        formater.dateFormat = format
        
        return formater.string(from: self)
    }
    /// 判断时间戳是否为今天
    ///
    /// - Parameter tp: 时间戳
    /// - Returns: Bool
    static func IsToday(tp: String) -> Bool{
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        
        let timeSp = TimeInterval(tp)
        
        guard timeSp != nil else {
            
            return false
        }
        
        let date = Date.init(timeIntervalSince1970: timeSp!)
        
        let cmps = calendar.dateComponents(unit, from: date)
        
        return (cmps.year == nowComps.year) &&
        (cmps.month == nowComps.month) &&
        (cmps.day == nowComps.day)
    }
    
    static func IsWeekData(tp: TimeInterval) -> Bool{
        let dayTime = Date().timeIntervalSince1970
        if (dayTime - tp) > 3600 * 7 * 24 {
            return true
        }
        return false
    }
}
