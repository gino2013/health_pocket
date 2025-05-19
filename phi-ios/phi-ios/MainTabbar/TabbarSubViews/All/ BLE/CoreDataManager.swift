//
//  CoreDataManager.swift
//  BleDemo2024
//
//  Created by Kenneth Wu on 2024/12/6.
//

import CoreData

/*
 // 保存上下文
 CoreDataManager.shared.saveContext()
 
 // 獲取上下文
 let context = CoreDataManager.shared.persistentContainer.viewContext
 */

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BleDemo2024")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMeasurement(systolic: Int16, diastolic: Int16) {
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "BloodPressure", in: context)!
        let newRecord = NSManagedObject(entity: entity, insertInto: context)
        newRecord.setValue(systolic, forKey: "systolic")
        newRecord.setValue(diastolic, forKey: "diastolic")
        newRecord.setValue(Date(), forKey: "timestamp")
        
        do {
            try context.save()
            print("數據已保存")
        } catch {
            print("保存失敗：\(error.localizedDescription)")
        }
    }
    
    private init() {} // 私有初始化方法确保单例
}
