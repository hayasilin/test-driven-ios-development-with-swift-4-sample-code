//
//  ViewController.swift
//  UnitTestDemo
//
//  Created by KuanWei on 2018/11/29.
//  Copyright © 2018 Kuan-Wei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewContext = app.persistentContainer.viewContext
        print(NSPersistentContainer.defaultDirectoryURL())

//        insertUserData()
//        queryUserData()
    }

    func insertUserData() {
        var user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.iid = "A01"
        user.cname = "David"

        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.iid = "A02"
        user.cname = "Lee"

        app.saveContext()
    }

    func queryUserData() {
        do {
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData] {
                print("\(String(describing: user.iid)), \(String(describing: user.cname))")
            }
        } catch {
            print(error)
        }
    }
}

