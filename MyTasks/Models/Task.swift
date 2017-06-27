//
//  Task.swift
//  MyTasks
//
//  Created by Amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var author: String?
    @NSManaged var date: Date?
}
