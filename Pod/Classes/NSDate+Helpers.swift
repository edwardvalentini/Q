//
//  NSDate+Helpers.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import Foundation

extension NSDate {
    convenience init?(dateString:String) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        if let d = formatter.dateFromString(dateString) {
            self.init(timeInterval:0, sinceDate:d)
        } else {
            self.init(timeInterval:0, sinceDate:NSDate())
            return nil
        }
    }
    
    var isoFormatter: ISOFormatter {
        if let formatter = objc_getAssociatedObject(self, "formatter") as? ISOFormatter {
            return formatter
        } else {
            let formatter = ISOFormatter()
            objc_setAssociatedObject(self, "formatter", formatter, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return formatter
        }
    }
    
    func toISOString() -> String {
        return self.isoFormatter.stringFromDate(self)
    }
}

class ISOFormatter : NSDateFormatter {
    override init() {
        super.init()
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        self.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        self.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
