//
//  QSerializerNSDefaults.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import Foundation
import UIKit

@objc open class QSerializerNSDefaults: NSObject, QSerializerPrototol {
    
    open func serializeOperation(_ operation: QOperation, queue: Q) {
        
        if let queueName = queue.name {
            if let serialized = operation.toJSONString() {
                let defaults = UserDefaults.standard
                var stringArray: [String]
                    if let curStringArray = defaults.stringArray(forKey: queueName) {
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
    
    open func deSerializedOperations(queue: Q) -> [QOperation] {
        let defaults = UserDefaults.standard
        if  let queueName = queue.name,
            let stringArray = defaults.stringArray(forKey: queueName) {
                print(stringArray.count)
                return stringArray
                    .map { return QOperation(json: $0, queue: queue)}
                    .filter { return $0 != nil }
                    .map { return $0! }
        }
        return []
    }
    
    open func removeOperation(_ operationID: String, queue: Q) {
        if let queueName = queue.name {
            var curArray: [QOperation] = deSerializedOperations(queue: queue)
            curArray = curArray.filter {return $0.operationID != operationID }
            let stringArray = curArray
                .map {return $0.toJSONString() }
                .filter { return $0 != nil}
                .map { return $0! }
            UserDefaults.standard.setValue(stringArray, forKey: queueName)
        }
    }
    
    
    
    
}
