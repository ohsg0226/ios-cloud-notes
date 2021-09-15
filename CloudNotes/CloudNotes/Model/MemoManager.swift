//
//  MemoManager.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/15.
//

import UIKit
import CoreData

enum MemoError: Error {
    case fetch
    case save
    case delete
    case edit
    case unowned
    
    var description: String {
        switch self {
        case .fetch:
            return "fetchError : 데이터를 불러오는데 실패했습니다"
        case .save:
            return "saveError : 데이터를 저장하는데 실패했습니다"
        case .delete:
            return "deleteError : 데이터를 삭제하는데 실패했습니다"
        case .edit:
            return "returnError : 데이터를 수정하는데 실패했습니다"
        default:
            return "unownedError : 알 수없는 에러가 발생했습니다"
        }
    }
}

class MemoManager {
    static var shared = MemoManager()
    
    var list = [Memo]()
    
    func fetch() throws -> [Memo]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.fetch
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        do {
            let result = try context.fetch(fetchRequest)
            guard let memoObject = result as? [Memo] else {
                throw MemoError.fetch
            }
            list = memoObject
        } catch {
            throw MemoError.unowned
        }
        return list
    }
    
    func save(title: String, contents: String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.save
        }
        let context = appDelegate.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "date")
        guard let memoObject = object as? Memo else {
            throw MemoError.save
        }
        do {
            try context.save()
            list.append(memoObject)
        } catch {
            context.rollback()
            throw MemoError.unowned
        }
    }
    
    func delete(index: Int) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.delete
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
            list.remove(at: index)
        } catch {
            context.rollback()
        }
    }
    
    func edit(title: String, contents: String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.edit
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
            self.list = try self.fetch()
        } catch {
            context.rollback()
        }
    }
}
