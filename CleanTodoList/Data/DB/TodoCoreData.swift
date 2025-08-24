//
//  CoreDataManager.swift
//  CleanTodoList
//
//  Created by Apple on 5/21/25.
//

import UIKit
import CoreData
import RxSwift

protocol TodoCoreDataProtocol {
    func saveTodoItem(item: TodoItem) -> Single<Bool>
    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]>
    func updateTodoItem(item: TodoItem) -> Single<TodoItem>
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem>
}

struct TodoCoreData: TodoCoreDataProtocol {
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTodoItem(item: TodoItem) -> Single<Bool> {
        return Single.create { single in
            guard let entity = NSEntityDescription.entity(forEntityName: "CleanTodoList", in: viewContext) else {
                single(.failure(CoreDataError.EntityNotFound("CleanTodoList")))
                return Disposables.create()
            }
            
            let todoItem = NSManagedObject(entity: entity, insertInto: viewContext)
            todoItem.setValue(item.uuid, forKey: "uuid")
            todoItem.setValue(item.title, forKey: "title")
            todoItem.setValue(item.done, forKey: "done")
            todoItem.setValue(item.date, forKey: "date")
            
            do {
                try viewContext.save()
                single(.success(true))
            } catch {
                single(.failure(CoreDataError.SaveError(error.localizedDescription)))
            }
            
            return Disposables.create()
        }
    }

    func readTodoList(page: Int, limit: Int, type: FilterType) -> Single<[TodoItem]> {
        return Single.create { single in
            let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
            fetchRequest.fetchLimit = limit
            fetchRequest.fetchOffset = (page - 1) * limit
            
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = type == .all ? nil : NSPredicate(format: "done == true")
            
            do {
                let result = try viewContext.fetch(fetchRequest)
                let todoItemList: [TodoItem] = result.compactMap { item in
                    guard let title = item.title, let uuid = item.uuid, let date = item.date else {
                        return nil }
                    return TodoItem(uuid: uuid, title: title, done: item.done, date: date)
                }
                single(.success(todoItemList))
            } catch {
                single(.failure(CoreDataError.ReadError(error.localizedDescription)))
            }
            
            return Disposables.create()
        }
    }
    
    func updateTodoItem(item: TodoItem) -> Single<TodoItem> {
        return Single.create { single in
            let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", item.uuid.uuidString)
            
            do {
                let results = try viewContext.fetch(fetchRequest)
                guard let itemToUpdate = results.first else {
                    single(.failure(CoreDataError.EntityNotFound("CleanTodoList with id \(item.uuid.uuidString)")))
                    return Disposables.create()
                }
                
                itemToUpdate.title = item.title
                itemToUpdate.done = item.done
                itemToUpdate.date = item.date
                
                try viewContext.save()
                single(.success(item))
            } catch {
                single(.failure(CoreDataError.updateError(error.localizedDescription)))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteTodoItem(item: TodoItem) -> Single<TodoItem> {
        return Single.create { single in
            let fetchRequest: NSFetchRequest<CleanTodoList> = CleanTodoList.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", item.uuid.uuidString)
            
            do {
                let results = try viewContext.fetch(fetchRequest)
                results.forEach { viewContext.delete($0) }
                
                try viewContext.save()
                single(.success(item))
            } catch {
                single(.failure(CoreDataError.deleteError(error.localizedDescription)))
            }
            
            return Disposables.create()
        }
    }


}


