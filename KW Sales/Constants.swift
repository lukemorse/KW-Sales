//
//  Constants.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Constants {
    
    struct TabBarImageName {
        static let tabBar0 = "plus.square.fill"
        static let tabBar1 = "clock.fill"
        static let tabBar2 = "checkmark.circle.fill"
        static let tabBar3 = "pencil"
    }
    
    struct TabBarText {
        static let tabBar0 = "Add District"
        static let tabBar1 = "Pending"
        static let tabBar2 = "Completed"
        static let tabBar3 = "Edit"
    }
    
    static let kFloorPlanCollection = "floorPlansCollection"
    static let kFloorPlanFolder = "floorPlansFolder"
    static let kDistrictCollection = "districts"
    static let kTeamCollection = "teams"
    static let kImplementationPlanCollection = "implementationPlans"
    
    static let chicagoGeoPoint = GeoPoint(latitude: 41.8781, longitude: -87.6298)
}
