//
//  StorageManager.swift
//  SkillboxDrive
//
//  Created by Руслан Шигапов on 03.05.2023.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cache")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data loading error: \(error)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveFile(_ name: String?,
                  _ preview: String?,
                  _ created: String?,
                  _ type: String?,
                  _ size: Int64?,
                  fromList: String) {
        let file = File(context: viewContext)
        file.name = name
        file.preview = preview
        file.created = created
        file.type = type
        file.size = size ?? 0
        file.relateTo = fromList
        saveContext()
    }
    
    func fetchFiles(completion: (Result<[File], Error>) -> Void) {
        let fetchRequest = File.fetchRequest()
        do {
            let files = try viewContext.fetch(fetchRequest)
            completion(.success(files))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteFiles() {
        let fetchRequest = File.fetchRequest()
        do {
            let files = try viewContext.fetch(fetchRequest)
            files.forEach { viewContext.delete($0) }
            saveContext()
        } catch {
            viewContext.rollback()
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
