//
//  PodMapModel.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase
import CodableFirebase

struct PodMapModel: Codable {
    
    let id: String
    var pods: [[String: [Float]]]
//    var pods: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case pods
    }
}
