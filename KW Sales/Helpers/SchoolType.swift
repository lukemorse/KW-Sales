//
//  SchoolType.swift
//  KW Sales
//
//  Created by Luke Morse on 6/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation

enum SchoolType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case unknown
    case preKSchool
    case elementary
    case middleSchool
    case highSchool
    
    var description: String {
        switch self {
        case .unknown: return "Unknown School Type"
        case .preKSchool: return "Pre K School"
        case .elementary: return "Elementary School"
        case .middleSchool: return "Middle School"
        case .highSchool: return "High School"
        }
    }
}
