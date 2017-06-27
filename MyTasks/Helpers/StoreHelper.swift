//
//  StoreHelper.swift
//  MyTasks
//
//  Created by Amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import Foundation
import UIKit
import CoreStore



private struct Static {
    
    
    static let sqliteFileURL = "db.sqlite"
    
    
    static let taskStack: DataStack = {
        
        let dataStack = DataStack(xcodeModelName: "MyTasks")
        try! dataStack.addStorageAndWait(
            SQLiteStore(
                fileName: sqliteFileURL,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        
        return dataStack
    }()
    
    
}



class StoreHelper:NSObject{
    
    public class var sharedInstance:StoreHelper {
        struct Singleton {
            static let instance = StoreHelper()
        }
        
        return Singleton.instance
    }
    
    
    public var dataStack: DataStack
    
    
    override init() {
        
        dataStack = Static.taskStack
        
        super.init()
        
        CoreStore.defaultStack = Static.taskStack
    }
     
    
    
}
