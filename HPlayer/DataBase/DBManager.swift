//
//  DBManager.swift
//  TBPlixor
//
//  Created by HF on 2023/12/21.
//

import Foundation
import CoreData

class DBManager {
    static let share = DBManager()
    static let applicationDocumentsDirectoryName = "com.coredata.hp"
    static let mainStoreFileName = "Data.sqlite"
    static let errorDomain = "DataManager"
    
//    var dataArr: [AccountModel] = []
    lazy var managedObjectModel: NSManagedObjectModel = {
        // 对应存储的模型CoreData.xcdatamodeld
        let modelURL = Bundle.main.url(forResource: "HPlayer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // 持久化协调器
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            // 自动升级选项设置
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL as URL, options: options)
        }
        catch {
            fatalError("持久化存储错误: \(error).")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    lazy var context: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // 避免多线程中出现问题，如果有属性和内存中都发生了改变，以内存中的改变为主
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return moc
    }()
    
    
    /// CoreData 文件存储目录
    //
    lazy var applicationSupportDirectory: URL = {
        
        let manager = FileManager.default
        var support: URL = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        var saveUrl:URL = support.appendingPathComponent(DBManager.applicationDocumentsDirectoryName)
        
        if manager.fileExists(atPath: saveUrl.path) == false {
            let path = saveUrl.path
            print("文件存储路径:\(path)")
            do {
                
                try manager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                fatalError("FlyElephant文件存储目录创建失败: \(path).")
            }
        }
        
        return saveUrl
    }()
    
    
    lazy var storeURL: URL = {
        return self.applicationSupportDirectory.appendingPathComponent(DBManager.mainStoreFileName)
    }()
    
    
    // 创建私有CoreData存储线程
    func newPrivateQueueContextWithNewPSC() throws -> NSManagedObjectContext {
        
        // 子线程中创建新的持久化协调器
        //
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: DBManager.share.managedObjectModel)
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: DBManager.share.storeURL as URL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.performAndWait() {
            
            context.persistentStoreCoordinator = coordinator
            
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
        }
        
        return context
    }
    
    // MARK: - AV 增、删、改、查
    
    func updateData(_ model: AVDataInfoModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        if let m: AVDB = findAVDataWithModel(id: model.id) {
            m.ssn_eps = model.ss_eps
            if model.ssn_id.count > 0 {
                m.ssn_id = model.ssn_id
            }
            if model.eps_id.count > 0 {
                m.eps_id = model.eps_id
            }
            m.type = Int16(model.type)
            m.updateTime = Double(Date().timeIntervalSince1970)
        } else {
            let m: AVModel = AVModel()
            m.id = model.id
            m.title = model.title
            m.cover = model.cover
            m.uploadTime = model.pub_date
            m.rate = model.rate
            m.type = model.type
            m.ssn_eps = model.ss_eps
            m.ssn_id = model.ssn_id
            m.eps_id = model.eps_id
            m.quality = model.quality
            m.country = model.country
            m.updateTime = Double(Date().timeIntervalSince1970)
            self.insertData(mod: m)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updateData(_ model: AVModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        if let m: AVDB = findAVDataWithModel(id: model.id, ssn_id: model.ssn_id, eps_id: model.eps_id) {
            m.title = model.title
            m.ssn_eps = model.ssn_eps
            m.type = Int16(model.type)
            m.ssn_name = model.ssn_name
            if model.ssn_id.count > 0 {
                m.ssn_id = model.ssn_id
            }
            if model.eps_id.count > 0 {
                m.eps_id = model.eps_id
            }
            m.cover = model.cover
            m.rate = model.rate
            m.eps_num = Int16(model.eps_num) ?? 1
            m.eps_name = model.eps_name
            m.quality = model.quality
            m.updateTime = Double(Date().timeIntervalSince1970)
        } else {
            model.updateTime = Double(Date().timeIntervalSince1970)
            self.insertData(mod: model)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updatePlayData(_ model: AVModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        if let m: AVDB = findAVDataWithModel(id: model.id, ssn_id: model.ssn_id, eps_id: model.eps_id) {
            if model.ssn_id.count > 0 {
                m.ssn_id = model.ssn_id
            }
            if model.eps_id.count > 0 {
                m.eps_id = model.eps_id
            }
            m.cover = model.cover
            m.ssn_eps = model.ssn_eps
            m.playProgress = model.playProgress
            m.totalTime = model.totalTime
            m.playedTime = model.playedTime
            m.delete = false
            m.updateTime = Double(Date().timeIntervalSince1970)
        } else {
            model.updateTime = Double(Date().timeIntervalSince1970)
            self.insertData(mod: model)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updateCaptionsData(_ model: AVModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        if let m: AVDB = findAVDataWithModel(id: model.id, ssn_id: model.ssn_id, eps_id: model.eps_id) {
            m.captions = model.captions as [AVCaption]
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertData(mod: AVModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        let m = NSEntityDescription.insertNewObject(forEntityName: "AVDB", into: context) as! AVDB
        m.id = mod.id
        m.type = Int16(mod.type)
        m.title = mod.title
        m.ssn_eps = mod.ssn_eps
        m.ssn_id = mod.ssn_id
        m.eps_id = mod.eps_id
        m.eps_name = mod.eps_name
        m.ssn_name = mod.ssn_name
        m.eps_num = Int16(mod.eps_num) ?? 1
        m.rate = mod.rate
        m.path = mod.video
        m.quality = mod.quality
        m.cover = mod.cover
        m.uploadTime = mod.uploadTime
        m.totalTime = mod.totalTime
        m.playedTime = mod.playedTime
        m.playProgress = mod.playProgress
        m.updateTime = Double(Date().timeIntervalSince1970)
        m.format = mod.format
        m.captions = mod.captions as [AVCaption]
        do {
            try context.save()
        } catch { }
    }
    
    func deleteAllData() {
        let context:NSManagedObjectContext = DBManager.share.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AVDB")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
     
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func deleteData(_ model: AVModel) {
        let context:NSManagedObjectContext = DBManager.share.context
        if let m: AVDB = findAVDataWithModel(id: model.id, ssn_id: model.ssn_id, eps_id: model.eps_id) {
            m.delete = true
            m.updateTime = Double(Date().timeIntervalSince1970)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func findAVDataWithModel(id: String, ssn_id: String = "", eps_id: String = "") -> AVDB? {
        let context:NSManagedObjectContext = DBManager.share.context
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AVDB")
        request.sortDescriptors = [NSSortDescriptor.init(key: "updateTime", ascending: false)]
        if ssn_id.isEmpty, eps_id.isEmpty {
            request.predicate = NSPredicate(format: "id=%@", id)
        } else {
            request.predicate = NSPredicate(format: "id=%@ AND ssn_id=%@ AND eps_id=%@", id, ssn_id, eps_id)
        }
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                if let model:AVDB = results.first as? AVDB {
                    return model
                }
            } else {
                return nil
            }
        } catch  {
            print(error)
        }
        return nil
    }
    
    func selectAVData(id: String, ssn_id: String = "", eps_id: String = "") -> AVModel? {
        let context:NSManagedObjectContext = DBManager.share.context
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AVDB")
        request.sortDescriptors = [NSSortDescriptor.init(key: "updateTime", ascending: false)]
        if ssn_id.isEmpty, eps_id.isEmpty {
            request.predicate = NSPredicate(format: "id=%@", id)
        } else {
            request.predicate = NSPredicate(format: "id=%@ AND ssn_id=%@ AND eps_id=%@", id, ssn_id, eps_id)
        }

        do {
            let results = try context.fetch(request)
            if let mod = results.first as? AVDB {
                let m = AVModel()
                m.id = mod.id ?? ""
                m.type = Int(mod.type)
                m.title = mod.title ?? ""
                m.ssn_eps = mod.ssn_eps ?? ""
                m.ssn_id = mod.ssn_id ?? ""
                m.eps_id = mod.eps_id ?? ""
                m.eps_name = mod.eps_name ?? ""
                m.ssn_name = mod.ssn_name ?? ""
                m.eps_num = "\(mod.eps_num)"
                m.cover = mod.cover ?? ""
                m.uploadTime = mod.uploadTime ?? ""
                m.totalTime = mod.totalTime
                m.quality = mod.quality ?? ""
                m.playedTime = mod.playedTime
                m.playProgress = mod.playProgress
                m.updateTime = mod.updateTime
                m.rate = mod.rate ?? ""
                m.video = mod.path ?? ""
                m.format = mod.format ?? ""
                m.midCaptions = mod.captions ?? []
                return m
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func selectHistoryDatas() ->Array<AVDataInfoModel> {
        let context: NSManagedObjectContext = DBManager.share.context
        let fetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AVDB")
        fetch.sortDescriptors = [NSSortDescriptor.init(key: "updateTime", ascending: false)]

        var dataArray = Array<AVDataInfoModel>()
        do {
            let results = try context.fetch(fetch)
            if results.count > 0 {
                dataArray.removeAll()
                for model in results {
                    if let mod = model as? AVDB, mod.playProgress > 0 {
                        /*只取播放记录里最新的一条，主要是对TV筛选*/
                        if let _ = dataArray.first(where: {$0.id == mod.id}) {
                            continue
                        }
                        let m = AVDataInfoModel()
                        m.id = mod.id ?? ""
                        m.title = mod.title ?? ""
                        m.type = Int(mod.type)
                        m.ssn_id = mod.ssn_id ?? ""
                        m.eps_id = mod.eps_id ?? ""
                        m.ssn_eps = mod.ssn_eps ?? ""
                        m.cover = mod.cover ?? ""
                        m.isDelete = mod.delete
                        m.quality = mod.quality ?? ""
                        m.rate = mod.rate ?? ""
                        m.playProgress = mod.playProgress
                        dataArray.append(m)
                    }
                }
            }
            return dataArray.filter({ $0.isDelete == false })
        } catch  {
            return dataArray
        }
    }
}
