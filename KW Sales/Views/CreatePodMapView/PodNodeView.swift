//
//  PodNodeView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/16/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodNodeView: Identifiable, Hashable, Equatable, View {
    
    var id: Int { hashValue }
    var pod: Pod
    var isDragging = false
    
    @State private var position = CGSize.zero
    
    static func == (lhs: PodNodeView, rhs: PodNodeView) -> Bool {
        return lhs.pod == rhs.pod && lhs.pod == rhs.pod
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pod.position.x)
        hasher.combine(pod.position.y)
        hasher.combine(pod.podType)
    }
    
    var body: some View {
        Image(podImageDict[self.pod.podType] ?? "")
            .resizable()
            .scaledToFit()
            .frame(
                width: self.pod.podType == .horizontal_hallway ? 12.5 : 7.5,
                height: self.pod.podType == .vertical_hallway ? 12.5 : 7.5)
            .position(pod.position)
            .colorMultiply(Color.red)
    }
}

enum PodType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case outdoor, corner, horizontal_hallway, vertical_hallway
    
    var description: String {
        switch self {
        case .outdoor:
            return "outdoor"
        case .corner:
            return "corner"
        case .horizontal_hallway:
            return "hallway"
        case .vertical_hallway:
            return "vertical hallway"
        }
    }
}


let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .horizontal_hallway : "horizontal hallway pod",
    .vertical_hallway : "vertical hallway pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PodNodeView(pod: Pod(podType: .corner, position: CGPoint(x: 100, y: 100)))
        }
        
    }
}
