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
//            
//            let widow = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
//                context) as! Friend
//            widow.name = "Widowmaker"
//            widow.profileImageName = "widowmaker"
            
//            let widow = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
//                context) as! Friend
//            widow.name = "Widowmaker"
//            widow.profileImageName = "widowmaker"
            
//            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into:
//                context) as! Message
//            message.friend = widow
//            message.text = "No one can hide from my side. I almost feel something!"
//            message.date = NSDate()
            
            createTraceMessagesWith(context: context)
            
            let reaper = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
                context) as! Friend
            reaper.name = "Reaper"
            reaper.profileImageName = "reaperImg"
            
            FriendsController.createMessageWith(text: "Death walks among you.", friend: reaper, minutesAgo: 5, context: context)
            
            let mercy = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
                context) as! Friend
            mercy.name = "Mercy"
            mercy.profileImageName = "mercyImg"
            
            FriendsController.createMessageWith(text: "A moment to enjoy some peace and quiet, probably just a moment though.", friend: mercy, minutesAgo: 60 * 24, context: context)
            
            let mccree = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
                context) as! Friend
            mccree.name = "Mccree"
            mccree.profileImageName = "mccreeImg"
            
            FriendsController.createMessageWith(text: "Well, it's high noon somewhere in the world.", friend: mccree, minutesAgo: 60 * 24 * 10, context: context)
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    private func createTraceMessagesWith(context: NSManagedObjectContext) {
        let tracer = NSEntityDescription.insertNewObject(forEntityName: "Friend", into:
            context) as! Friend
        tracer.name = "Tracer"
        tracer.profileImageName = "tracerImg"
        
        FriendsController.createMessageWith(text: "Cheers love!", friend: tracer, minutesAgo: 3, context: context)
        FriendsController.createMessageWith(text: "The Cavalry's here! What did I get?! What did I get?!", friend: tracer, minutesAgo: 2, context: context)
        FriendsController.createMessageWith(text: "My ultimate is charging. Let's try that again. Ever get that feeling of déjà vu? Ugh! Someone help me move this thing! They've got a teleporter, we've got to find it.", friend: tracer, minutesAgo: 1, context: context)
        
        // response message 
        FriendsController.createMessageWith(text: "Sometimes I feel a little sick after using my Translocator, I'm sure you know what I mean, Tracer.", friend: tracer, minutesAgo: 1, context: context, isSender: true)

        FriendsController.createMessageWith(text: "Won't be a problem if you just disappeared forever. Don't think I don't recognize that device of yours. I know you stole it!", friend: tracer, minutesAgo: 1, context: context)
        
        FriendsController.createMessageWith(text: "What can I say? A girl just has to have the latest tech.", friend: tracer, minutesAgo: 1, context: context, isSender: true)
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    print(friend.name as Any)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
        }
    }
    
    static func createMessageWith(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext,
                                   isSender: Bool = false) -> Message{
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into:
            context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        
        return message
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                return try context.fetch(request) as? [Friend]
                
            } catch let err {
                print(err)
            }
        }
        
        return nil
    }
    
}
