import Foundation

let formatter = NSDateIntervalFormatter()

let date1 = NSDate(timeIntervalSince1970: 0)
let date2 = NSDate(timeIntervalSince1970: 0.1)

formatter.stringFromDate(date1, toDate: date2)
