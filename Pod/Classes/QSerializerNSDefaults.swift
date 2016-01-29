//
//  QSerializerNSDefaults.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import Foundation
import UIKit

@objc public class QSerializerNSDefaults: NSObject, QSerializerPrototol {
    
    public func serializeOperation(operation: QOperation, queue: Q) {
        
        if let queueName = queue.name {
            if let serialized = operation.toJSONString() {
                let defaults = NSUserDefaults.standardUserDefaults()
                var stringArray: [String]
                    if let curStringArray = defaults.stringArrayForKey(queueName) {
                        stringArray = curStringArray
                        stringArray.append(serialized)
                    } else {
                        stringArray = [serialized]
                    }
                    defaults.setValue(stringArray, forKey: queueName)
                    defaults.synchronize()
                
                    print("operation \(operation.operationID) was serialized")
                } else {
                    print("unable to serialize operation - error")
                }
            
        } else {
            print("no queue name for queue - error")
        }
            
    }
    
    public func deSerializedOperations(queue queue: Q) -> [QOperation] {
        let defaults = NSUserDefaults.standardUserDefaults()
        if  let queueName = queue.name,
            let stringArray = defaults.stringArrayForKey(queueName) {
                print(stringArray.count)
                return stringArray
                    .map { return QOperation(json: $0, queue: queue)}
                    .filter { return $0 != nil }
                    .map { return $0! }
        }
        return []
    }
    
    public func removeOperation(operationID: String, queue: Q) {
        if let queueName = queue.name {
            var curArray: [QOperation] = deSerializedOperations(queue: queue)
            curArray = curArray.filter {return $0.operationID != operationID }
            let stringArray = curArray
                .map {return $0.toJSONString() }
                .filter { return $0 != nil}
                .map { return $0! }
            NSUserDefaults.standardUserDefaults().setValue(stringArray, forKey: queueName)
        }
    }
    
    
    
    
}
