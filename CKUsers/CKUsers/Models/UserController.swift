//
//  UserController.swift
//  CKUsers
//
//  Created by Blake kvarfordt on 8/27/19.
//  Copyright © 2019 Blake kvarfordt. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    
    static let shared = UserController()
    
    var currentUser: User?
    let database = CKContainer.default().publicCloudDatabase
    
    
    func createUserWith(email: String, username: String, petName: String, completion: @escaping (Bool) -> Void) {
        
        
        CKContainer.default().fetchUserRecordID { (appleCKReferenceID, error) in
            
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let appleCKReferenceID = appleCKReferenceID else { completion(false); return }
            let appleCKReference = CKRecord.Reference(recordID: appleCKReferenceID, action: CKRecord.Reference.Action.deleteSelf)
            
            let user = User(email: email, username: username, petName: petName, appleCKReference: appleCKReference)
            let userRecord = CKRecord(user: user)
            self.database.save(userRecord, completionHandler: { (record, error) in
                
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let record = record else { completion(false); return }
                guard let user = User(ckRecord: record) else { completion(false); return }
                self.currentUser = user
                completion(true)
                
            })
        }
        
    }
    
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleCKRefereneceID, error) in
            
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let appleCKReferenceID = appleCKRefereneceID else { return }
            let appleCKReference = CKRecord.Reference(recordID: appleCKReferenceID, action: .deleteSelf)
            let predicate = NSPredicate(format: "appleCKReference == %@", appleCKReference)
            let query = CKQuery(recordType: "User", predicate: predicate)
            self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let records = records, // Unwrap array of records
                    let firstRecord = records.first, // Get the first (and hopefully only) record
                    let currentUser = User(ckRecord: firstRecord) else { completion(false); return } // Create a new user from that first record
                
                self.currentUser = currentUser // Set the User to the source of Truth
                completion(true)
                
            })
        }
    }
}
