//
//  NSBundle+QBundle.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
//

import Foundation

public extension NSBundle {
    public class func qBundle() -> NSBundle {
        return NSBundle(forClass: self)
    }
    
    public class func qAssetsBundle() -> NSBundle {
        let path : NSString = NSBundle.qBundle().resourcePath! as NSString
        let assetPath = path.stringByAppendingPathComponent("QAssets.bundle")
        return NSBundle(path: assetPath)!
    }
    
    public class func qLocalizedStringForKey(key: String) -> String {
        return NSLocalizedString(key, tableName: "Q", bundle: NSBundle.qAssetsBundle(), comment: "")
    }
    
    public class func qImageWithName(name: String, type: String) -> UIImage? {
        let bundle = NSBundle.qAssetsBundle()
        if let path = bundle.pathForResource(name, ofType: type, inDirectory: "Images") {
            return UIImage(named: path)
        } else {
            return nil
        }
    }
}