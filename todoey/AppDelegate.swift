//
//  AppDelegate.swift
//  todoey
//
//  Created by Apple on 12/27/17.
//  Copyright © 2017 Amin Torabi. All rights reserved.
//

import UIKit

import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//       print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("error initialising realm \(error)")
        }
        
            return true
    }

 
   
   
}

