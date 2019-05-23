//
//  CoreDataHelper.swift
//  translator
//
//  Created by TONY on 21/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum CoreDataErrors: Error {
    case loadError
    case saveError
}

class CoreDataHelper {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func save() throws {
        let context = getContext()
        do {
            try context.save()
        } catch {
            throw CoreDataErrors.saveError
        }
    }
    
    func add(inputedText: String, source: String, target: String, translatedText: String) throws -> Translator {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Translator", in: context)
        let newItem = Translator(entity: entity!, insertInto: context)

        newItem.inputedText = inputedText
        newItem.source = source
        newItem.target = target
        newItem.translatedText = translatedText
        
        try save()
        
        return newItem
    }
    
    func load() throws -> [Translator] {
        let context = getContext()
        
        let request = NSFetchRequest<Translator>(entityName: "Translator")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Translator.objectID), ascending: false)]
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            throw CoreDataErrors.loadError
        }
    }
}
