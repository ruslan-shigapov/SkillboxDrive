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
        container.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func saveData(_ name: String?, _ created: String?, _ size: Int64, _ preview: String?, fromList: String) {
        let file = File(context: viewContext)
        file.name = name
        file.created = created
        file.size = size
        file.preview = preview
        file.fromList = fromList
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
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
            }
        }
    }
}
