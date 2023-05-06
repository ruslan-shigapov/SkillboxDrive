//
//  StorageManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 03.05.2023.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private let viewContext: NSManagedObjectContext
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cache")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func save(_ name: String?, _ created: String?, _ size: Int64?, _ preview: String?) {
        let file = File(context: viewContext)
        file.name = name
        file.created = created
        file.size = size ?? 0
        file.preview = preview
        saveContext()
    }
    func fetchData(completion: (Result<[File], Error>) -> Void) {
        let fetchRequest = File.fetchRequest()
        do {
            let files = try viewContext.fetch(fetchRequest)
            completion(.success(files))
        } catch let error {
            completion(.failure(error))
        }
    }
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

