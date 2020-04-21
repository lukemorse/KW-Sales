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
    @State var position = CGSize.zero
    
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    @State var transformationMatrix: [CGFloat] = [1,0,0,1,0,0]
    
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Image("floorPlan")
                    .resizable()
                self.circle
            }
            .scaledToFit()
            .animation(.linear)
            .scaleEffect(self.scale)
            .offset(self.dragSize)
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.scale = self.scale * delta
                
            }.onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
                self.scale(x: val, y: val)
                }
                
            )
                .simultaneousGesture(DragGesture(minimumDistance: 1, coordinateSpace: .local).onChanged({ val in
                    print("dragging map")
                    self.tapPoint = val.startLocation
                    self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                })
                    .onEnded({ (val) in
                        self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                        self.lastDrag = self.dragSize
                        self.translate(x: self.dragSize.width, y: self.dragSize.height)
                    }))
                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ (val) in
                    
                        
                        // TODO: Fix tap point when scaled
                    let tapPoint = CGPoint(x: (val.startLocation.x - self.dragSize.width) / self.scale, y: (val.startLocation.y - self.dragSize.height) / self.scale)
                    print("width: \(self.dragSize.width)")
//                    let tapPoint = self.getNewXY(mouseX: val.location.x, mouseY: val.location.y)
                        self.circlePosition = tapPoint
                }))
            Spacer()
        }
    }
    
    var circle: some View {
        Circle()
            .frame(width: 20, height: 20, alignment: .center)
        .position(circlePosition)
    }
    
    func translate(x: CGFloat, y: CGFloat) {
        transformationMatrix[4] += transformationMatrix[0] * x + transformationMatrix[2] * y
        transformationMatrix[5] += transformationMatrix[1] * x + transformationMatrix[3] * y
    }
    
    func scale(x: CGFloat, y: CGFloat) {
        transformationMatrix[0] *= x
        transformationMatrix[1] *= x
        transformationMatrix[2] *= y
        transformationMatrix[3] *= y
    }
    
    func getNewXY(mouseX: CGFloat, mouseY: CGFloat) -> CGPoint {
        let newX = mouseX * transformationMatrix[0] + mouseY * transformationMatrix[2] + transformationMatrix[4]
        let newY = mouseX * transformationMatrix[1] + mouseY * transformationMatrix[3] + transformationMatrix[5]
        return CGPoint(x: newX, y: newY)
    }
}





struct PodMapTest_Previews: PreviewProvider {
    static var previews: some View {
        PodMapTest()
    }
}


