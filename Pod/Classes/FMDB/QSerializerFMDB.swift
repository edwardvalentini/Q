//
//  QSerializerFMDB.swift
//  Pods
//
//  Created by Edward Valentini on 1/28/16.
//

import UIKit
import FMDB


let kTABLE_Q                         = "qoperationmodel"
let kCOLUMN_Q_ID                     = "q_id"
let kCOLUMN_UUID                     = "uuid"
let kCOLUMN_SQL_ID                   = "id"
let kCOLUMN_Q_QUEUENAME              = "queuename"
let kCOLUMN_Q_OPERATION_ID           = "operation_id"
let kCOLUMN_Q_TIMESTAMP              = "timestamp"
let kCOLUMN_Q_OPERATION              = "operation"

let kSQLITE_FILENAME                 = "q.sqlite"

@objc public class QSerializerFMDB: NSObject, QSerializerPrototol {
    
    
    // need to create the database. 
    

    public func serializeOperation(operation: QOperation, queue: Q) {
        if let queueName = queue.name {
            
            if let serialized = operation.toJSONString() {
                let opID = operation.operationID
                let timestamp = operation.created.timeIntervalSince1970
                
                
                
                
                let countquery = "SELECT COUNT(*) AS count FROM \(kTABLE_Q) WHERE \(kCOLUMN_Q_OPERATION_ID) = \"\(opID)\";"
                
             //   print(countquery)

                
                let dbq = FMDatabaseQueue(path: getDbFilename()!)
                
                var opExists : Bool = false
                
                dbq?.inDatabase({ (db) -> Void in
                    if let rs = db.executeQuery(countquery, withArgumentsInArray: nil) {
                        while rs.next()  {
                            let res = rs.resultDictionary()
                            if let resCount = res["count"]?.integerValue {
                            
                             //   print("COUNT IS \(resCount)")
                                if resCount > 0 {
                                    opExists = true
                                }
                            }
                        }
                    }
                })
                
                if !opExists {

                    let query = "INSERT INTO \(kTABLE_Q)( \(kCOLUMN_SQL_ID), \(kCOLUMN_Q_OPERATION_ID), \(kCOLUMN_Q_QUEUENAME), \(kCOLUMN_Q_OPERATION), \(kCOLUMN_Q_TIMESTAMP)) VALUES (NULL,?,?,?,?);"

                    //print(query)
                    
                    dbq?.inTransaction({ (db, rollback) -> Void in
                        if !db.executeUpdate(query, withArgumentsInArray: [opID,queueName,serialized,timestamp]) {
                            print("insert failure: \(db.lastErrorMessage())")
                            rollback.initialize(true)
                            return
                        }
                    })
                    
                
                
                }
                
                
            }
        }

    }

    public func deSerializedOperations(queue queue: Q) -> [QOperation] {
        if let queueName = queue.name {
            let query = "SELECT * FROM \(kTABLE_Q) WHERE \(kCOLUMN_Q_QUEUENAME) = \"\(queueName)\";"
            //print(query)
            
            
            let dbq = FMDatabaseQueue(path: getDbFilename()!)
            
            
            dbq?.inDatabase({ (db) -> Void in
                if let rs = db.executeQuery(query, withArgumentsInArray: nil) {
                    while rs.next()  {
                     //   let res = rs.resultDictionary()
                        //if let resCount = res["count"]?.integerValue {
                        
                            // need to come back to this .... 
                        
                          //  print("res IS \(res)")
//                            if resCount > 0 {
//                                opExists = true
//                            }
                       // }
                    }
                }
            })
            
            
            
        }
        return []

    }

    public func removeOperation(operationID: String, queue: Q) {
        if let queueName = queue.name {
            let query = "DELETE FROM \(kTABLE_Q) WHERE \(kCOLUMN_Q_QUEUENAME) = \"\(queueName)\" AND \(kCOLUMN_Q_OPERATION_ID) = \"\(operationID)\";"
          //  print(query)
            
            let dbq = FMDatabaseQueue(path: getDbFilename()!)

            
            dbq?.inTransaction({ (db, rollback) -> Void in
                if !db.executeUpdate(query, withArgumentsInArray: nil) {
                    print("delete failure: \(db.lastErrorMessage())")
                    rollback.initialize(true)
                    return
                }
            })
            
        }
    }
    
    
    private func countOfOperationsWithID(operationID: String) -> NSInteger {
        
        
        return 0
    }
    
    private func findOperationWithID(operationID: String) -> QOperation? {
        return nil
    }
    
    private func findAllOperationsOnQueue(queue: Q) -> [QOperation] {
        return []
    }
    
    private func writeOperationToDB(operation: QOperation) -> Bool {
        return false
    }
    
    
    private func getDbFilename() -> String? {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let docFolderURL = NSURL(string: documentsFolder)
        let databasePath = docFolderURL?.URLByAppendingPathComponent(kSQLITE_FILENAME)
        return databasePath?.absoluteString
    }
    
    

}
