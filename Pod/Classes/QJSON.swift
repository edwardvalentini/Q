//
//  QJSON.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit

open class QJSON: NSObject {
    open class func toJSON(_ obj: AnyObject) throws -> String? {
        let json = try JSONSerialization.data(withJSONObject: obj, options: [])
        return NSString(data: json, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    open class func fromJSON(_ str: String) throws -> Any? {
        if let json = str.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let obj: Any = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
            return obj
        }
        return nil
    }
    
//    public class func runInBackgroundAfter(seconds: NSTimeInterval, callback:dispatch_block_t) {
//        let delta = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds) * Int64(NSEC_PER_SEC))
//        dispatch_after(delta, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), callback)
//    }
}
