//
//  Service.swift
//  FireChat
//
//  Created by Admin on 27/09/2022.
//

import Foundation
import FirebaseFirestore

struct Service {
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ documents in
                
                let dictionaty = documents.data()
                let user = User(dictionary: dictionaty)
                users.append(user)
                completion(users)
            })
        }
    }
}
