//
//  Users.swift
//  CoreDataCustomSwift
//
//  Created by Eric Douglas on 6/28/14.
//  Copyright (c) 2014 Eric Douglas. All rights reserved.
//

import UIKit
import CoreData

@objc(Users) // Make Users class available to obj-c libraries
class Users: NSManagedObject {
    
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var prefix: String
    var fullName: String {
        return self.prefix + (self.prefix != "" ? " " : "") + self.username
    }
    
    func toString() -> String {
        return "The username is \(self.fullName), their password is \(self.password)"
    }
    
    // Potential use case function
    func validPassword(inputPassword: String) -> Bool {
        return inputPassword == self.password
    }
    
}
