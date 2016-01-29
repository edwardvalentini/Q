//
//  QOperation.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit
import CocoaLumberjack

@objc public class QOperation: NSOperation {
    public let queue: Q
    public var operationID: String
    public var operationName: String
    public var retries: Int
    public var retryCount: Int = 0
    public let created: NSDate
    public var started: NSDate?
    public var userInfo: AnyObject?
    public var retryDelay: Int
    var error: NSError?
    public var operationBlock: QOperationBlock?
    
    var _executing: Bool = false
    var _finished: Bool = false
    
    public override var name: String? {get {return operationID } set { } }
    
    public override var executing: Bool {
        get { return _executing }
        set {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    public override var finished: Bool {
        get { return _finished }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    
    public init(queue: Q, operationID: String? = nil, operationName: String, userInfo: AnyObject? = nil,
        created: NSDate = NSDate(), started: NSDate? = nil ,
        retries: Int = 0, retryDelay: Int = 0, operationBlock: QOperationBlock? = nil) {
            self.queue = queue
            self.operationID = operationID ?? NSUUID().UUIDString
            self.operationName = operationName
            self.retries = retries
            self.created = created
            self.userInfo = userInfo
            self.retryDelay = retryDelay
            self.operationBlock = operationBlock
            self.started = started
            super.init()
    }
    
    public convenience init(queue: Q, name: String, userInfo: AnyObject? = nil, retries: Int = 0, retryDelay: Int = 0, operationBlock: QOperationBlock? = nil) {
        self.init(queue: queue, operationName: name, userInfo:userInfo, retries:retries, retryDelay: retryDelay, operationBlock: operationBlock)
    }
    
    public init?(dictionary: QJSONDictionary, queue: Q) {
        if  let operationID = dictionary["operationID"] as? String,
            let operationName = dictionary["operationName"] as? String,
            let data: AnyObject? = dictionary["userInfo"] as AnyObject??,
            let createdStr = dictionary["created"] as? String,
            let startedStr: String? = dictionary["started"] as? String ?? nil,
            let retries = dictionary["retries"] as? Int? ?? 0,
            let retryDelay =  dictionary["retryDelay"] as? Int? ?? 0
        {
            let created = NSDate(dateString: createdStr) ?? NSDate()
            let started = (startedStr != nil) ? NSDate(dateString: startedStr!) : nil
            
            self.queue = queue
            self.operationID = operationID ?? NSUUID().UUIDString
            self.operationName = operationName
            self.retries = retries
            self.created = created
            self.userInfo = data
            self.retryDelay = retryDelay
            self.started = started
            super.init()
        } else {
            //self.init(queue: queue, operationID: "", operationName: "")
            self.queue = queue
            self.operationName = ""
            self.operationID = ""
            self.retries = 0
            self.created = NSDate()
            self.userInfo = nil
            self.retryDelay = 0
            self.started = nil
            super.init()
            return nil
        }
    }
    
    public convenience init?(json: String, queue: Q) {
        do {
            if let dict = try QJSON.fromJSON(json) as? [String: AnyObject] {
                self.init(dictionary: dict, queue: queue)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    public func completeOperation() {
        self.completeOperation(nil)
    }
    
    public func failedRetries() -> Bool {
        return retryCount >= min(queue.maxRetries,retries)
    }
    
    public func completeOperation(error: NSError?) {
        if (!executing) {
            finished = true
            return
        }
        if let error = error {
            self.error = error
            self.retryCount++
            
            if failedRetries() {
                cancel()
                executing = false
                finished = true
                return
            }
            DDLogVerbose("INSIDE THE QOperation: Operation \(operationName) failed and we are on retry number \(retryCount) of \(min(queue.maxRetries,retries)) times with \(retryDelay) seconds between retries...")
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(retryDelay) * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.main()
            }
            
        
        } else {
            executing = false
            finished = true
        }
    }
    
    // MARK: - overide method
    
    
    override public func main() {
        if cancelled && !finished { finished = true }
        if finished { return }
        
        super.main()
        
        if let block = self.operationBlock  {
            block(self)
        }
    }
    
    
    public override func start() {
        super.start()
        executing = true
    }
    
    public override func cancel() {
        super.cancel()
        finished = true
    }
    
    
    // MARK: - JSON Helpers
    
    public func toJSONString() -> String? {
        let dict = toDictionary()
        
        let nsdict = NSMutableDictionary(capacity: dict.count)
        for (key, value) in dict {
            nsdict[key] = value ?? NSNull()
        }
        do {
            let json = try QJSON.toJSON(nsdict)
            return json
        } catch {
            return nil
        }
    }
    
    public func toDictionary() -> [String: AnyObject?] {
        var dict = [String: AnyObject?]()
        
        dict["operationID"] = self.operationID
        dict["operationName"] = self.operationName
        dict["created"] = self.created.toISOString()
        dict["started"] = (self.started != nil) ? self.started!.toISOString() : nil
        dict["retries"] = self.retries
        dict["userInfo"] = self.userInfo
        dict["retryDelay"] = self.retryDelay
        return dict
    }

    
}


