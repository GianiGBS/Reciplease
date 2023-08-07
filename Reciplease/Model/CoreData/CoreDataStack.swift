//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 30/05/2023.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Singleton
    
    static let sharedInstance = CoreDataStack()
    
    // MARK: - Proprieties
    
    private let persistentContainerName = "Reciplease"
    var storeContainer: NSPersistentContainer!
    
    // MARK: - Public
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
    
    // MARK: - Private
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let  error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)" )
            }
        })
        return container
    }()
}
