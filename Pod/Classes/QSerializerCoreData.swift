//
//  QSerializerCoreData.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
//

import UIKit
import CoreData


open class QSerializerCoreData: QSerializerPrototol {

    open func serializeOperation(_ operation: QOperation, queue: Q) {
        
    }
    
    open func deSerializedOperations(queue: Q) -> [QOperation] {
        return []
    }
    
    open func removeOperation(_ operationID: String, queue: Q) {
        
    }
}
