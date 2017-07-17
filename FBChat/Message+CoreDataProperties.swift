//
//  Message+CoreDataProperties.swift
//  FBChat
//
//  Created by e.bateeva on 17.07.17.
//  Copyright © 2017 Катя. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var friend: Friend?

}
