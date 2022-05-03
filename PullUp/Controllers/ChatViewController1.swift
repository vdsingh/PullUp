import UIKit
////
////  ChatViewController.swift
////  PullUp
////
////  Created by Vikram Singh on 1/1/22.
////
//
//import Foundation
import MessageKit

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType{
    var senderId: String
    var displayName: String
    var photoURL: String
}

class ChatViewController: MessagesViewController{
    private var messages = [Message]()
    private let selfSender = Sender(senderId: "1", displayName: "Vik", photoURL: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("HELLO WORLD MESSAGE")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("HELLO WORLD MESSAGE")))

        view.backgroundColor = .red
//        backgroundColor
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
}
