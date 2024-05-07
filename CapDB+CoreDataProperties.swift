//
//  CapDB+CoreDataProperties.swift
//  HPlayer
//
//  Created by HF on 2024/5/6.
//  Copyright © 2024 HPlayer. All rights reserved.
//
//

import Foundation
import CoreData


extension CapDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CapDB> {
        return NSFetchRequest<CapDB>(entityName: "CapDB")
    }

    @NSManaged public var captionId: String?
    @NSManaged public var display_name: String?
    @NSManaged public var local_address: String?
    @NSManaged public var name: String?
    @NSManaged public var original_address: String?
    @NSManaged public var short_name: String?
    @NSManaged public var capShip: AVDB?

}

extension CapDB : Identifiable {

}
