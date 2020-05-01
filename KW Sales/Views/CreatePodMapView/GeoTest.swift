//
//  GeoTest.swift
//  KW Sales
//
//  Created by Luke Morse on 4/30/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//
import SwiftUI

struct Outlicious: View {
    @State var circlePosition = CGPoint.zero
    var body: some View {
        
        ZStack {
            Image("floorPlan")
                .resizable()
                .scaledToFit()
                .scaleEffect(3)
                .overlay(gesture)
            circle
        }
        .coordinateSpace(name: "custom")
        //            Inlicious()
        
    }
    
    
    
    var gesture: some View {
        
        return GeometryReader {geo in
            Color.clear.contentShape(Rectangle())
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(AnyHashable("custom")))
        .onChanged({ (value) in
            print(value.location)
            self.circlePosition = value.location
        })
        )
    }
    
    var circle: some View {
        
        Circle()
            .frame(width: 15, height: 15, alignment: .center)
            .position(circlePosition)
    }
    
}

struct GeoTest_Previews: PreviewProvider {
    static var previews: some View {
        Outlicious()
            
    }
}
