//
//  User.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/12/21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login : String = ""
    @objc dynamic var password : String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
