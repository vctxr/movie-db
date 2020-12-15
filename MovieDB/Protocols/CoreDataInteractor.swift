//
//  CoreDataInteractor.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import UIKit
import CoreData

protocol CoreDataInteractor {
    var viewContext: NSManagedObjectContext { get }
}

extension CoreDataInteractor {
    
    var viewContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
