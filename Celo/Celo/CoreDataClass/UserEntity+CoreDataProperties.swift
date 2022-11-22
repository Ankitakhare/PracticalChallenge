//
//  UserEntity+CoreDataProperties.swift
//  Celo
//
//  Created by ankita khare on 16/11/22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var fullName: String?
    @NSManaged public var gender: String?
    @NSManaged public var address: String?
    @NSManaged public var dob: String?
    @NSManaged public var phone: String?
    @NSManaged public var picture: Data?

}

extension UserEntity : Identifiable {

}
