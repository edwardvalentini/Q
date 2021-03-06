//
//  QSerializerProtocol.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
import UIKit

public protocol QSerializerPrototol {
    func serializeOperation(_ operation: QOperation, queue: Q)
    func deSerializedOperations(queue: Q) -> [QOperation]
    func removeOperation(_ operationID: String, queue: Q)
}
