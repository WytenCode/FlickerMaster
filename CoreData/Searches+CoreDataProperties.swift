//
//  Searches+CoreDataProperties.swift
//  LCTUrlProj
//
//  Created by Владимир on 20/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//
//

import Foundation
import CoreData


extension Searches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Searches> {
        return NSFetchRequest<Searches>(entityName: "Searches")
    }

    @NSManaged public var searchString: String?

}
