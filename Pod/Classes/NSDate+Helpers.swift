//
//  NSDate+Helpers.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import Foundation

extension Date {
    init?(dateString:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        if let d = formatter.date(from: dateString) {
            (self as NSDate).init(timeInterval:0, since:d)
        } else {
            (self as NSDate).init(timeInterval:0, since:Date())
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
        return self.isoFormatter.string(from: self)
    }
}

class ISOFormatter : DateFormatter {
    override init() {
        super.init()
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        self.timeZone = TimeZone(secondsFromGMT: 0)
        self.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
