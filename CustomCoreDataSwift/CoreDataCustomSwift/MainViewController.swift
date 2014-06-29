//
//  MainViewController.swift
//  CoreDataCustomSwift
//
//  Created by Eric Douglas on 6/28/14.
//  Copyright (c) 2014 Eric Douglas. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet var textUsername: UITextField
    @IBOutlet var textPassword: UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedSaveButton() {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext
        let ent = NSEntityDescription.entityForName("Users", inManagedObjectContext: context)
        let newUser = Users(entity: ent, insertIntoManagedObjectContext: context)
        newUser.username = self.textUsername.text
        newUser.password = self.textPassword.text
        newUser.prefix = ""
        context.save(nil) // No error handling
    }
    
    @IBAction func pressedLoadButton() {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", self.textUsername.text)
        let results = context.executeFetchRequest(request, error: nil) as Array<Users> // No error handling
        if results.count > 0 {
            for user in results {
                println(user.toString())
                user.prefix = user.prefix != "" ? "" : "Count"
                println(user.toString())
            }
            println("\(results.count) found")
        } else {
            println("No results found")
        }
    }

}
