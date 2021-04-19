//
//  MapPoint.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/9/21.
//

import Foundation
import RealmSwift

class MapPoint: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
