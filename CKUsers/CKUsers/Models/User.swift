//
//  User.swift
//  CKUsers
//
//  Created by Blake kvarfordt on 8/27/19.
//  Copyright © 2019 Blake kvarfordt. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
    let email: String
    let username: String
    let petName: String
    
    
    var ckRecordID: CKRecord.ID? // your custom user record's record ID
    let appleCKReference: CKRecord.Reference // reference to our custom icloud user
    
    
    init(email: String, username: String, petName: String, appleCKReference: CKRecord.Reference) {
        self.email = email
        self.username = username
        self.petName = petName
        self.appleCKReference = appleCKReference
        
    }
    
    init?(ckRecord: CKRecord) {
        guard let username = ckRecord["username"] as? String,
        let email = ckRecord["email"] as? String,
        let petName = ckRecord["petName"] as? String,
        let appleCKReference = ckRecord["appleCKReference"] as? CKRecord.Reference else { return nil }
        
        self.username = username
        self.email = email
        self.petName = petName
        self.appleCKReference = appleCKReference
        self.ckRecordID = ckRecord.recordID
    }
}


extension CKRecord {
    
    convenience init(user: User) {
        
        // Use the users id if we have a user, if we dont, create a new one
        let recordID = user.ckRecordID ?? CKRecord.ID(recordName: UUID().uuidString)
        
        // Designated initializer
        self.init(recordType: "User", recordID: recordID)
        
        // set the values
        self.setValue(user.username, forKey: "username")
        self.setValue(user.email, forKey: "email")
        self.setValue(user.petName, forKey: "petName")
        self.setValue(user.appleCKReference, forKey: "appleCKReference")
        
    }
}
