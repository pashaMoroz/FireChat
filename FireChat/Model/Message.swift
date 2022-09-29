//
//  Message.swift
//  FireChat
//
//  Created by Admin on 28/09/2022.
//

import FirebaseAuth
import FirebaseFirestore

struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionaty: [String: Any]) {
        self.text = dictionaty["text"] as? String ?? ""
        self.toId = dictionaty["toId"] as? String ?? ""
        self.fromId = dictionaty["fromId"] as? String ?? ""
        self.timestamp = dictionaty["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let mesasge: Message
}
