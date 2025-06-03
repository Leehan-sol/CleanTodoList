//
//  CoreDataManager.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import UIKit
import CoreData

protocol TodoCoreDataProtocol {
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func readTodoList() -> Result<[TodoItem], CoreDataError>
    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError>
}

struct TodoCoreData: TodoCoreDataProtocol {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "CleanTodoList", in: viewContext) else {
            return .failure(.EntityNotFound("CleanTodoList"))
        }
        let todoItem = NSManagedObject(entity: entity, insertInto: viewContext)
        todoItem.setValue(item.uuid, forKey: "uuid")
        todoItem.setValue(item.title, forKey: "title")
        todoItem.setValue(item.done, forKey: "done")
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.SaveError(error.localizedDescription))
        }
    }
    
    func readTodoList() -> Result<[TodoItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let todoItemList: [TodoItem] = result.compactMap { item in
                guard let title = item.title, let uuid = item.uuid else {
                    return nil }
                return TodoItem(uuid: uuid, title: title, done: item.done)
            }
            return .success(todoItemList)
        } catch {
            return .failure(.ReadError(error.localizedDescription))
        }
    }

    func updateTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", item.uuid.uuidString)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            guard let itemToUpdate = results.first else {
                return .failure(.EntityNotFound("CleanTodoList with id \(item.uuid.uuidString)"))
            }
            
            itemToUpdate.title = item.title
            itemToUpdate.done = item.done
            
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.updateError(error.localizedDescription))
        }
    }
    
    func deleteTodoItem(item: TodoItem) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", item.uuid.uuidString)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { item in
                viewContext.delete(item)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.DeleteError(error.localizedDescription))
        }
    }
    
}


