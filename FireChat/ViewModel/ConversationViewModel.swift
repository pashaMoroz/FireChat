//
//  ConversationViewModel.swift
//  FireChat
//
//  Created by Admin on 29/09/2022.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImgeUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.mesasge.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
