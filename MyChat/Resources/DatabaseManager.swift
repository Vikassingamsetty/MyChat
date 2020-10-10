//
//  DatabaseManager.swift
//  MyChat
//
//  Created by vikas on 10/10/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
 
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
    
}

//MARK:- Account Management
extension DatabaseManager {
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)){
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    ///inserts new user to database
    public func inserUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "first_name":user.firstName,
            "last_name":user.lastName
        ])
    }
}

struct ChatAppUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
//    let profilePictureUrl:String
}
