//
//  QSerializerProtocol.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
import UIKit

@objc public protocol QSerializerPrototol: NSObjectProtocol {
    func serializeOperation(operation: QOperation, queue: Q)
    func deSerializedOperations(queue queue: Q) -> [QOperation]
    func removeOperation(operationID: String, queue: Q)
}
