//
//  ChatViewController.swift
//  PullUp
//
//  Created by Vikram Singh on 1/1/22.
//

import Foundation
import MessageKit
class ChatViewController1: MessagesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

let sender = Sender(senderId: "any_unique_id", displayName: "Steven")
let messages: [MessageType] = []

extension ChatViewController1: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: "any_unique_id", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatViewController1: MessagesLayoutDelegate{
    
}

extension ChatViewController1: MessagesDisplayDelegate{
    
}
