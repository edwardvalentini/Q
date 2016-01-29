//
//  QSerializerCoreData.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
//

import UIKit
import CoreData


@objc public class QSerializerCoreData: NSObject, QSerializerPrototol {
    
    
    
    public func serializeOperation(operation: QOperation, queue: Q) {
        
    }
    
    public func deSerializedOperations(queue queue: Q) -> [QOperation] {
        return []
    }
    
    public func removeOperation(operationID: String, queue: Q) {
        
    }
}
