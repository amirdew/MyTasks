//
//  TaskRepository.swift
//  MyTasks
//
//  Created by Amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import CoreStore

class TaskRepository {
    
    public class func fetchAll() -> [Task]{
    
        return StoreHelper.sharedInstance.dataStack.fetchAll(From(Task.self)) ?? []
    }
    
    
    
    public class func new(name:String, date:Date, author:String, desc:String){
        
        _ = try? StoreHelper.sharedInstance.dataStack.perform(
            synchronous: { (transaction) in 
                
                let newTask = transaction.create(Into<Task>())
                newTask.name = name
                newTask.author = author
                newTask.date = date
                newTask.desc = desc
          }
        )
        
    }

    
    public class func remove(task:Task){
        
        _ = try? StoreHelper.sharedInstance.dataStack.perform(
            synchronous: { (transaction) in
                
                transaction.delete(task)
          }
        )
    }
    
    
    public class func edit(task:Task){
        
        _ = try? StoreHelper.sharedInstance.dataStack.perform(
            synchronous: { (transaction) in
                
                transaction.edit(task)
        }
        )
    }

}
