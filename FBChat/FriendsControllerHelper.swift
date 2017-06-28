//
//  FriendsControllerHelper.swift
//  FBChat
//
//  Created by Катя on 28/06/2017.
//  Copyright © 2017 Катя. All rights reserved.
//

import UIKit

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}

class Message: NSObject {
    var text: String?
    var date: NSDate?
    
    var friend: Friend?
}

extension FriendsController {
    
    func setupData() {
        let widow = Friend()
        widow.name = "Widowmaker"
        widow.profileImageName = "widowmaker"
        
        let message = Message()
        message.friend = widow
        message.text = "Hello. My name is Amelie. Nice to meet you..."
        message.date = NSDate()
        
        let tracer = Friend()
        tracer.name = "Tracer"
        tracer.profileImageName = "tracerImg"
        
        let messageTracer = Message()
        messageTracer.friend = tracer
        messageTracer.text = "Cheers love! The Cavalry's here!"
        messageTracer.date = NSDate()
        
        messages = [message]
    }
    
}
