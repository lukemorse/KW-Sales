//
//  Enums.swift
//  KW Sales
//
//  Created by Luke Morse on 6/12/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation

enum DistrictStatus: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case pending
    case complete
    
    var description: String {
        switch self {
        case .pending: return "pending"
        case .complete: return "complete"
        }
    }
}

enum InstallationStatus: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case notStarted
    case inProgress
    case complete
    
    var description: String {
        switch self {
        case .notStarted: return "Not Started"
        case .inProgress: return "In Progress"
        case .complete: return "Complete"
        }
    }
}

enum DistrictFilter {
    case noFilter, pending, complete, currentUser
}
