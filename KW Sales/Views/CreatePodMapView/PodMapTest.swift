//
//  PodMapTest.swift
//  KW Sales
//
//  Created by Luke Morse on 4/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodMapTest: View {
    
    @State var circlePosition = CGPoint.zero
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State var tapPoint: CGPoint = CGPoint.zero
    
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        
        VStack {
            Spacer()
            ZStack {
                Image("floorPlan")
                    .resizable()
                self.circle
                gesture
            }
            .coordinateSpace(name: "custom")
            .scaledToFit()
            .scaleEffect(self.scale)
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.scale = self.scale * delta
                if self.scale < 1 {self.scale = 1}
                }
            )
            Spacer()
        }
    }
    
    var gesture: some View {
        GeometryReader { geo in
            EmptyView()
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace:
                //                .named("custom")
                .named(AnyHashable("custom"))
            ).onChanged({ (val) in
                // TODO: Fix tap point when scaled
                let tapPoint = CGPoint(x: (val.startLocation.x) / self.scale, y: (val.startLocation.y) / self.scale)
                self.circlePosition = tapPoint
                print(tapPoint)
            })
        )
    }
    
    var circle: some View {
        
        Circle()
            .frame(width: 15, height: 15, alignment: .center)
            .position(circlePosition)
    }
}



struct PodMapTest_Previews: PreviewProvider {
    static var previews: some View {
        PodMapTest()
    }
}


