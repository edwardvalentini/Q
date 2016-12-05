//
//  QOperation.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit
import CocoaLumberjack

open class QOperation: Operation {
    open let queue: Q
    open var operationID: String
    open var operationName: String
    open var retries: Int
    open var retryCount: Int = 0
    open let created: Date
    open var started: Date?
    open var userInfo: AnyObject?
    open var retryDelay: Int
    var error: NSError?
    open var operationBlock: QOperationBlock?
    
    var _executing: Bool = false
    var _finished: Bool = false
    
    open override var name: String? {get {return operationID } set { } }
    
    open override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    open override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    
    public init(queue: Q, operationID: String? = nil, operationName: String, userInfo: AnyObject? = nil,
        created: Date = Date(), started: Date? = nil ,
        retries: Int = 0, retryDelay: Int = 0, operationBlock: QOperationBlock? = nil) {
            self.queue = queue
            self.operationID = operationID ?? UUID().uuidString
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
            let created = Date(dateString: createdStr) ?? Date()
            let started = (startedStr != nil) ? Date(dateString: startedStr!) : nil
            
            self.queue = queue
            self.operationID = operationID ?? UUID().uuidString
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
            self.created = Date()
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

    open func completeOperation() {
        self.completeOperation(nil)
    }
    
    open func failedRetries() -> Bool {
        return retryCount >= min(queue.maxRetries,retries)
    }
    
    open func completeOperation(_ error: NSError?) {
        if (!isExecuting) {
            isFinished = true
            return
        }
        if let error = error {
            self.error = error
            self.retryCount += 1
            
            if failedRetries() {
                cancel()
                isExecuting = false
                isFinished = true
                return
            }
            DDLogVerbose("INSIDE THE QOperation: Operation \(operationName) failed and we are on retry number \(retryCount) of \(min(queue.maxRetries,retries)) times with \(retryDelay) seconds between retries...")
            
            let delayTime = DispatchTime.now() + Double(Int64(Double(retryDelay) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.main()
            }
            
        
        } else {
            isExecuting = false
            isFinished = true
        }
    }
    
    // MARK: - overide method
    
    
    override open func main() {
        if isCancelled && !isFinished { isFinished = true }
        if isFinished { return }
        
        super.main()
        
        if let block = self.operationBlock  {
            block(self)
        }
    }
    
    
    open override func start() {
        super.start()
        isExecuting = true
    }
    
    open override func cancel() {
        super.cancel()
        isFinished = true
    }
    
    
    // MARK: - JSON Helpers
    
    open func toJSONString() -> String? {
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
    
    open func toDictionary() -> [AnyHashable: Any] {
        var dict : [AnyHashable: Any] = [:]
        
        dict["operationID"] = self.operationID
        dict["operationName"] = self.operationName
        dict["created"] = self.created.toISOString()
        dict["started"] =  self.started!.toISOString()
        dict["retries"] = self.retries
        dict["userInfo"] = self.userInfo
        dict["retryDelay"] = self.retryDelay
        return dict
    }

    
}


