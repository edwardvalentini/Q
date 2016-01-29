//
//  Q.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit
import CocoaLumberjack

public typealias QOperationBlock = (QOperation) -> Void
public typealias QJSONDictionary = [String: AnyObject]


@objc public class Q: NSOperationQueue {
    
    public let maxRetries: Int
    var opList = [String: QOperation]()
    let serializationProvider: QSerializerPrototol?
    
    public required init(queueName: String,
        maxConcurrency: Int = 1,
        maxRetries: Int = 5,
        serializationProvider: QSerializerPrototol? = nil ) {
            self.maxRetries = maxRetries
            self.serializationProvider = serializationProvider
            super.init()
            self.name = queueName
            self.maxConcurrentOperationCount = maxConcurrency
    }
    
    
    
    public func hasUnfinishedOperations() -> Bool {
        return serializationProvider?.deSerializedOperations(queue: self).count > 0
    }
    
    public func start() {
        self.suspended = false
    }
    
    public func pause() {
        self.suspended = true
    }
    
    public func loadSerializedOperations() {
        DDLogVerbose("not implemented yet")
//        self.pause()
//        if let ops = serializationProvider?.deSerializedOperations(queue: self) {
//            for op in ops {
//                addDeserializedOperation(op)
//            }
//        }
//        self.start()
    }
    
    private func addDeserializedOperation(operation: QOperation) {
        if opList[operation.operationID] != nil {
            return
        }
        opList[operation.operationID] = operation
        operation.completionBlock = { self.operationComplete(operation) }
        super.addOperation(operation)
    }
    
//    public func addOperationWithName(name: String, retries: Int = 0, retryDelay: Int = 0, operationBlock: QOperationBlock) {
//        let op = QOperation(queue: self, name: name, userInfo: nil, retries: retries, retryDelay: retryDelay, operationBlock: operationBlock)
//        self.addOperation(op)
//    }
    
    
    public override func addOperation(op: NSOperation) {
        if let op = op as? QOperation {
            if opList[op.operationID] != nil {
                DDLogVerbose("error duplicate operation \(op.operationID)")
            }
            opList[op.operationID] = op
            if let sp = serializationProvider {
                sp.serializeOperation(op, queue: op.queue)
            }
            op.completionBlock = { self.operationComplete(op) }
        }
        super.addOperation(op)
    }
    
    
    private func operationComplete(op: NSOperation) {
        if let op = op as? QOperation {
            
            objc_sync_enter(opList)
            defer { objc_sync_exit(opList) }
            
            if opList.contains( {(item: String, qOp: QOperation) -> Bool in
                return qOp.operationID == op.operationID
            }) {
                opList.removeValueForKey(op.operationID)
                if let _ = op.error {
                    if op.failedRetries() {
                        DDLogVerbose("OUTSIDE IN THE Q: Operation \(op.operationName) failed all the retries.  There are \(opList.count) OTHER operations left.")
                    }
                } else {
                     DDLogVerbose("OUTSIDE IN THE Q: Operation \(op.operationName) completed. There are \(opList.count) OTHER operations left.  Namely: ")
                     DDLogVerbose("OUTSIDE IN THE Q: Operations: \(opList)")
                }

                if let sp = serializationProvider {
                    sp.removeOperation(op.operationID, queue: op.queue)
                }
            }
        }
    }
    

}
