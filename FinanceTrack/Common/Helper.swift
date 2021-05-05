import Foundation
import UIKit
import Charts

class Helper {
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    static func formateExpense(amount: Int) -> String {
        "\(amount) ₽"
    }
    
    static func getLastDays(for period: Period) -> [Date] {
        switch period {
        case .week:
            return getLastWeekDays()
        case .month:
            return getLastMonthDays()
        case .quarter:
            return getLastQuarterDays()
        default:
            return getLastWeekDays()
        }
    }
    
    static func getLastWeekDays() -> [Date] {
        var days: [Date] = []
        for i in (1...7).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
    
    static func getLastMonthDays() -> [Date] {
        var days: [Date] = []
        for i in (1...30).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
    
    static func getLastQuarterDays() -> [Date] {
        var days: [Date] = []
        for i in (1...90).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
}

extension Date {
    func getDateFor(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
    
    func monthDateFormate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd.MM"
        return df.string(from: self)
    }
    
    func trimTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: self)
        return dateFormatter.date(from: dateString.components(separatedBy: " ").first ?? "")!
    }
}

enum Period {
    case week
    case month
    case quarter
    case allTime
}

class CustomLabelsXAxisValueFormatter : NSObject, IAxisValueFormatter {
    var labels: [String] = []
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        guard let axis = axis, count > 0 else {
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}
