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
    
    static func formateExpense(amount: Double) -> String {
        "\(amount.removeZerosFromEnd()) ₽"
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
        for i in (0...6).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
    
    static func getLastMonthDays() -> [Date] {
        var days: [Date] = []
        for i in (0...29).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
    
    static func getLastQuarterDays() -> [Date] {
        var days: [Date] = []
        for i in (0...90).reversed() {
            days.append(Date().getDateFor(days: -i)!.trimTime())
        }
        return days
    }
    
    static func getDateInterval(period: Period) -> (start: Date, finish: Date) {
        let start = Date().trimTime()
        let finish: Date
        switch period {
        case .week:
            finish = Date().getDateFor(days: -7)!.trimTime()
        case .month:
            finish = Date().getDateFor(days: -30)!.trimTime()
        case .quarter:
            finish = Date().getDateFor(days: -90)!.trimTime()
        case .allTime:
            finish = Date().getDateFor(days: -100000)!.trimTime()
        }
        return (start, finish)
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

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
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

protocol BarChartDrawable {
    var barChartView: BarChartView! { get set }
    func customizeChart()
    func setChartData(labels: [String], data: [Double])
}

extension BarChartDrawable {
    func customizeChart() {
        barChartView.noDataText = "No data"
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yEntrySpace = 0.0;
        
        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.axisLineColor = UIColor.lightGray
        xaxis.granularityEnabled = true
        xaxis.enabled = true
        xaxis.labelFont = UIFont.systemFont(ofSize: 12)
        
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 10
        yaxis.drawGridLinesEnabled = false
        yaxis.axisLineColor = UIColor.lightGray
        yaxis.labelFont = UIFont.systemFont(ofSize: 12)
        
        barChartView.rightAxis.enabled = false
    }
    
    func setChartData(labels: [String], data: [Double]) {
        barChartView.noDataText = "Нет данных для отображения"
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<labels.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: data[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Траты за день")
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 12)
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        chartDataSet.colors = [UIColor(red: 29/255, green: 177/255, blue: 193/255, alpha: 1)]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.backgroundColor = UIColor.white
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        let xaxis = barChartView.xAxis
        let formatter = CustomLabelsXAxisValueFormatter()
        formatter.labels = labels
        xaxis.valueFormatter = formatter
    }
}

