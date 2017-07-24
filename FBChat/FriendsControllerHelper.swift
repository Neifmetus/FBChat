//
//  FriendsControllerHelper.swift
//  FBChat
//
//  Created by Катя on 28/06/2017.
//  Copyright © 2017 Катя. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
                
                try(context.save())
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let widow = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
                context) as! Friend
            
            widow.name = "Widowmaker"
            widow.profileImageName = "widowmaker"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into:
                context) as! Message
            message.friend = widow
            message.text = "No one can hide from my side. I almost feel something!"
            message.date = NSDate()
            
            let tracer = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
                context) as! Friend
            tracer.name = "Tracer"
            tracer.profileImageName = "tracerImg"
            
            let messageTracer = NSEntityDescription.insertNewObject(forEntityName: "Message", into:
                context) as! Message
            messageTracer.friend = tracer
            messageTracer.text = "Cheers love! The Cavalry's here!"
            messageTracer.date = NSDate()
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            
            do {
                messages = try(context.fetch(fetchRequest)) as? [Message]
             } catch let err {
                print(err)
            }
        }
    }
    
}
