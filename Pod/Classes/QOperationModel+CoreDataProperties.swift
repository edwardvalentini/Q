//
//  QOperationModel+CoreDataProperties.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension QOperationModel {

    @NSManaged var id: String?
    @NSManaged var uuid: String?
    @NSManaged var queue_name: String?
    @NSManaged var operation_id: String?
    @NSManaged var timestamp: Date?
    @NSManaged var operation: String?

}
