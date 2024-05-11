//
//  LikeDB+CoreDataProperties.swift
//  HPlayer
//
//  Created by HF on 2024/5/11.
//  Copyright © 2024 HPlayer. All rights reserved.
//
//

import Foundation
import CoreData


extension LikeDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeDB> {
        return NSFetchRequest<LikeDB>(entityName: "LikeDB")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var cover: String?
    @NSManaged public var rate: String?
    @NSManaged public var type: Int16
    @NSManaged public var time: Double

}

extension LikeDB : Identifiable {

}
