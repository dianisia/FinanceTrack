import Foundation
import UIKit

class Helper {
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    static func formateDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "d MMM y"
        return df.string(from: date)
    }

    static func formateExpense(amount: Int) -> String {
        "\(amount) ₽"
    }
    
    static func getLastWeekDays() -> [Date] {
        var days: [Date] = []
        for i in (1...7).reversed() {
            let currDate = Date().getDateFor(days: -i)
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.dateFormat = "dd-MM"
//            let lastWeekDateString = dateFormatter.string(from: currDate!)
            days.append(currDate!)
        }
        return days
    }
}

extension Date {
    func getDateFor(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
}

enum Period {
    case week
    case month
    case quarter
    case allTime
}
