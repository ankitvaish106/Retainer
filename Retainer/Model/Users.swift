//
//  User.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import  Firebase
class user: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var phoneNumber:String?
   // var online:String?
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["Name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        // self.online = dictionary["online"] as? String
    }
}

