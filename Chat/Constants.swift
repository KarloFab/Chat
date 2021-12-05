//
//  Constants.swift
//  Chat
//
//  Created by Karlo Fabijanić on 04.12.2021..
//

struct Constants {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginToChat = "LoginToChat"
    static let appTitle = "CHAT"
    
    struct FireStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
