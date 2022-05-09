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
import InputBarAccessoryView

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
    private var count = 0
    private var messages = [Message]()
    private let selfSender = Sender(senderId: "1", displayName: "Vik", photoURL: "")
    private let otherSender = Sender(senderId: "2", displayName: "Varshini", photoURL: "")
    override func viewDidLoad() {
        super.viewDidLoad()
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hey where are you guys?")))
//        messages.append(Message(sender: otherSender, messageId: "2", sentDate: Date(), kind: .text("We're in the orange section in LL of the library")))
//        messages.append(Message(sender: otherSender, messageId: "1", sentDate: Date(), kind: .text("kk - omw!")))


//        view.backgroundColor = .red
//        backgroundColor
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
//        title = "CS198J Session Chat"
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

extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("LOG: Send message button clicked. Text: \(text)")
        let selfSender = Sender(senderId: "1", displayName: "Vik", photoURL: "")
        let otherSender = Sender(senderId: "2", displayName: "Varshini", photoURL: "")
        
        if count == 0{
            messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hey where are you guys?")))
            count += 1
        }else if count == 1 {
            messages.append(Message(sender: otherSender, messageId: "2", sentDate: Date(), kind: .text("we're in the main library in the computer area!")))
            count += 1
        }else if count == 2{
            messages.append(Message(sender: selfSender, messageId: "3", sentDate: Date(), kind: .text("sounds good. be there in 5!")))
            count += 1
        }else if count == 3{
            messages.append(Message(sender: otherSender, messageId: "3", sentDate: Date(), kind: .text("see you then :)")))
            count += 1
        }
        messagesCollectionView.reloadData()
    }
}
