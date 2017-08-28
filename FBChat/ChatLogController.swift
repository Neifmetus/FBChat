//
//  ChatLogController.swift
//  FBChat
//
//  Created by e.bateeva on 26.07.17.
//  Copyright © 2017 Катя. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    
    var messages: [Message]?
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let inputTextField: UITextField = {
       let textField = UITextField()
       textField.placeholder = "Enter message..."
        
       return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleSend() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        
        let message = FriendsController.createMessageWith(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context!, isSender: true)
        
        do {
            try context?.save()
            
            messages?.append(message)
            
            let item = (messages?.count)! - 1
            let insertionPath = IndexPath(item: item, section: 0)
            collectionView?.insertItems(at: [insertionPath])
            collectionView?.scrollToItem(at: insertionPath, at: .bottom, animated: true)
            
            inputTextField.text = nil
            
        } catch let err {
            print(err)
        }
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWith(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWith(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func simulate() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        
        let message = FriendsController.createMessageWith(text: "We’ve gotta stop the payload.", friend: friend!, minutesAgo: 1, context: context!)
        
        do {
            try context?.save()
            
            messages?.append(message)
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending} )
            
            if let item = messages?.index(of: message) {
                let receivingIndexPath = IndexPath(item: item, section: 0)
                collectionView?.insertItems(at: [receivingIndexPath])
            }
            
        } catch let err {
            print(err)
        }
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print(keyboardFrame)
            
            let isShowing = notification.name == .UIKeyboardWillShow
            
            bottomConstraint?.constant = isShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isShowing {
                    let indexPath = IndexPath(row: (self.messages?.count)! - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func setupInputComponents() {
        let topBorderVuew = UIView()
        topBorderVuew.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderVuew)
        
        messageInputContainerView.addConstraintsWith(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWith(format: "V:|[v0]|", views: inputTextField)
        
        messageInputContainerView.addConstraintsWith(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWith(format: "H:|[v0]|", views: topBorderVuew)
        messageInputContainerView.addConstraintsWith(format: "V:|[v0(0.5)]", views: topBorderVuew)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!
            ChatLogMessageCell
            
            cell.messageTextView.text = messages?[indexPath.item].text
            
            if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName {
                
                cell.profileImageView.image = UIImage(named: profileImageName)
                
                let size = CGSize(width: 250, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
                
                if !message.isSender {
                    cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    
                    cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 30 + 6)
                    
                    cell.bubbleImageView.image = ChatLogMessageCell.incomingBubble
                    cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                    cell.messageTextView.textColor = UIColor.black
                    
                    cell.profileImageView.isHidden = false

                } else {
                    cell.messageTextView.frame = CGRect(x: view.frame.width - (estimatedFrame.width + 16) - 16 - 4, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    
                    cell.textBubbleView.frame = CGRect(x: view.frame.width - (estimatedFrame.width + 16 + 8) - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 30 + 6)
                    
                    cell.bubbleImageView.image = ChatLogMessageCell.outgoingBubble
                    cell.bubbleImageView.tintColor = UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1)
                    cell.messageTextView.textColor = UIColor.white
                    
                    cell.profileImageView.isHidden = true
                }
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let incomingBubble = UIImage(named: "incoming_message")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 30, 34)).withRenderingMode(.alwaysTemplate)
    static let outgoingBubble = UIImage(named: "outgoing")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 30, 34)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = incomingBubble
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        addSubview(profileImageView)
        addConstraintsWith(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWith(format: "V:[v0(30)]|", views: profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWith(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWith(format: "V:|[v0]|", views: bubbleImageView)
    }
}
