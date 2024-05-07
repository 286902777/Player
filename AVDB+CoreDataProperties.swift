//
//  AVDB+CoreDataProperties.swift
//  HPlayer
//
//  Created by HF on 2024/5/6.
//  Copyright © 2024 HPlayer. All rights reserved.
//
//

import Foundation
import CoreData


extension AVDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AVDB> {
        return NSFetchRequest<AVDB>(entityName: "AVDB")
    }

    @NSManaged public var captions: [AVCaption]?
    @NSManaged public var cover: String?
    @NSManaged public var dataSize: String?
    @NSManaged public var delete: Bool
    @NSManaged public var eps_id: String?
    @NSManaged public var eps_name: String?
    @NSManaged public var eps_num: Int16
    @NSManaged public var format: String?
    @NSManaged public var id: String?
    @NSManaged public var path: String?
    @NSManaged public var playedTime: Double
    @NSManaged public var playProgress: Double
    @NSManaged public var quality: String?
    @NSManaged public var rate: String?
    @NSManaged public var ssn_eps: String?
    @NSManaged public var ssn_id: String?
    @NSManaged public var ssn_name: String?
    @NSManaged public var title: String?
    @NSManaged public var totalTime: Double
    @NSManaged public var type: Int16
    @NSManaged public var updateTime: Double
    @NSManaged public var uploadTime: String?
    @NSManaged public var url: String?
    @NSManaged public var avShip: CapDB?

}

extension AVDB : Identifiable {

}
