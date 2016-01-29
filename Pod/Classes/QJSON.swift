//
//  QJSON.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit

@objc public class QJSON: NSObject {
    public class func toJSON(obj: AnyObject) throws -> String? {
        let json = try NSJSONSerialization.dataWithJSONObject(obj, options: [])
        return NSString(data: json, encoding: NSUTF8StringEncoding) as String?
    }
    
    public class func fromJSON(str: String) throws -> AnyObject? {
        if let json = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let obj: AnyObject = try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
            return obj
        }
        return nil
    }
    
//    public class func runInBackgroundAfter(seconds: NSTimeInterval, callback:dispatch_block_t) {
//        let delta = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds) * Int64(NSEC_PER_SEC))
//        dispatch_after(delta, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), callback)
//    }
}
