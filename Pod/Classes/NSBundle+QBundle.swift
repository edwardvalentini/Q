//
//  NSBundle+QBundle.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
//

import Foundation

public extension Bundle {
    public class func qBundle() -> Bundle {
        return Bundle(for: self)
    }
    
    public class func qAssetsBundle() -> Bundle {
        let path : NSString = Bundle.qBundle().resourcePath! as NSString
        let assetPath = path.appendingPathComponent("QAssets.bundle")
        return Bundle(path: assetPath)!
    }
    
    public class func qLocalizedStringForKey(_ key: String) -> String {
        return NSLocalizedString(key, tableName: "Q", bundle: Bundle.qAssetsBundle(), comment: "")
    }
    
    public class func qImageWithName(_ name: String, type: String) -> UIImage? {
        let bundle = Bundle.qAssetsBundle()
        if let path = bundle.path(forResource: name, ofType: type, inDirectory: "Images") {
            return UIImage(named: path)
        } else {
            return nil
        }
    }
}
