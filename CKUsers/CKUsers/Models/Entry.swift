//
//  Entry.swift
//  CKUsers
//
//  Created by Blake kvarfordt on 8/28/19.
//  Copyright © 2019 Blake kvarfordt. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    fileprivate let entryKey = "Entry"
    fileprivate let titleKey = "title"
    fileprivate let bodyKey = "body"
    fileprivate let appleUserReferenceKey = "apppleUserReference"
    var title: String
    var body: String
    var ckRecordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    init(title: String, body: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.title = title
        self.body = body
        self.ckRecordID = ckRecordID
        self.appleUserReference = appleUserReference
    }
    
    // This is coming back down from the cloud (fetching)
    init?(ckRecord: CKRecord) {
        guard let title = ckRecord[titleKey] as? String,
        let body = ckRecord[bodyKey] as? String,
            let appleUserReference = ckRecord[appleUserReferenceKey] as? CKRecord.Reference,
            // Check to see that the record type is an "Entry"
        ckRecord.recordType == entryKey else { return nil}
        
        self.title = title
        self.body = body
        self.ckRecordID = ckRecord.recordID
        self.appleUserReference = appleUserReference
    }
    
}

extension CKRecord {
    convenience init(entry: Entry) {
        let recordID = entry.ckRecordID
        
        // Calling the designated initializer
        self.init(recordType: entry.entryKey, recordID: recordID)
        
        // Set key value pairs for a CKRecord
        self.setValue(entry.title, forKey: entry.titleKey)
        self.setValue(entry.bodyKey, forKey: entry.bodyKey)
        self.setValue(entry.appleUserReference, forKey: entry.appleUserReferenceKey)
    }
}
