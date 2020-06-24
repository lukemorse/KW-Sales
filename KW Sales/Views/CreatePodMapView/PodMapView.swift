//
//  CreatePodMapView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct PodMapView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: PodMapViewModel
    var floorPlanIndex: Int
    
    @State var showImagePicker: Bool = false
    @State private var isShowingAlert = false
    @State var showingActionSheet = false
    @State private var position = CGSize.zero
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    
    @State var willPlacePod: Bool = false
    @State var draggedPodView: AnyView = AnyView(EmptyView())
    @State var nextPodType: PodType = .vertical_hallway
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: viewModel.url, cache: self.cache, placeholder: Text("Loading..."), configuration: {$0.resizable()})
                self.podGroup
            }
            .coordinateSpace(name: "custom")
            .if(willPlacePod) {$0.overlay(podPlacementGesture)}
            .scaledToFit()
            .animation(.none)
            .scaleEffect(self.scale)
            .offset(self.dragSize)
            
            Spacer()
            moveAndScaleButtons
            actionSheetButton
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(title: Text("Successfully Saved POD Map"))
        }
        .navigationBarItems(trailing: saveButton)
        .onAppear() {
            self.viewModel.fetchPods(floorNum: self.floorPlanIndex)
        }
    }
    
    var podPlacementGesture: some View {
        GeometryReader {geo in
            Color.clear.contentShape(Rectangle())
                
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(AnyHashable("custom")))
                    .onChanged({ (value) in
                        if self.willPlacePod {
                            let xMul = Float(value.location.x / geo.size.width)
                            let yMul = Float(value.location.y / geo.size.height)
                        self.draggedPodView = AnyView(PodNodeView(pod: Pod(podType: self.nextPodType, xMul: xMul, yMul: yMul))
                            .position(value.location))
                        }
                    })
                    .onEnded({ (value) in
                        if self.willPlacePod {
                            self.draggedPodView = AnyView(EmptyView())
                            let xMul = Float(value.location.x / geo.size.width)
                            let yMul = Float(value.location.y / geo.size.height)
                            let pod = Pod(podType: self.nextPodType, xMul: xMul, yMul: yMul)
                            self.viewModel.pods.append(pod)
                        }
                    })
            )
        }
    }
    
    
    var podGroup: some View {
        GeometryReader { geo in
            Group {
                ForEach(0..<self.viewModel.pods.count, id: \.self) { index in
                    PodNodeView(pod: self.viewModel.pods[index])
                        .position(CGPoint(x: geo.size.width * CGFloat(self.viewModel.pods[index].xMul), y: geo.size.height * CGFloat(self.viewModel.pods[index].yMul)))
                        .onTapGesture {
                            if !self.willPlacePod {
                                self.viewModel.pods.remove(at: index)
                            }
                    }
                }
                self.draggedPodView
            }
        }
    }
}

extension PodMapView {
    
    var saveButton: some View {
        Button(action: {
            self.viewModel.setPods(floorNum: self.floorPlanIndex) { success in
                if success {
                    self.isShowingAlert = true
                }
            }
        }) {
            Text("Save")
                .foregroundColor(.blue)
        }
    }
    
    var actionSheetButton: some View {
        Button(action: {
            self.showingActionSheet = true
        }) {
            Text("KW POD")
                .font(.title)
                .padding()
                .foregroundColor(Color.black)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding()
        }
        .actionSheet(isPresented: $showingActionSheet, content: {
            ActionSheet(title: Text("Add POD"), message: Text("Choose POD Type"), buttons:
                [
                    .default(Text("Outdoor POD"), action: {
                        self.nextPodType = .outdoor
                        self.willPlacePod = true
                    }),
                    .default(Text("Corner POD"), action: {
                        self.nextPodType = .corner
                        self.willPlacePod = true
                    }),
                    .default(Text("Horizontal Hallway POD"), action: {
                        self.nextPodType = .horizontal_hallway
                        self.willPlacePod = true
                    }),
                    .default(Text("Vertical Hallway POD"), action: {
                        self.nextPodType = .vertical_hallway
                        self.willPlacePod = true
                    }),
                    .default(Text("Delete POD"), action: {
                        self.willPlacePod = false
                    }),
                    .cancel()])
        })
    }
    
    var moveAndScaleButtons: some View {
        HStack {
            VStack(spacing: 50) {
                button_scaleUp
                button_scaleDown
            }
            Spacer()
            VStack {
                button_moveUp
                HStack {
                    button_moveLeft
                    button_moveRight
                }
                button_moveDown
            }
        }
    }
    
    func getButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .foregroundColor(Color.white)
                .font(.headline)
                .padding()
                .foregroundColor(Color.black)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 30))
        }
    }
    
    var button_moveUp: some View {
        getButton(imageName: "arrow.up", action: {
            self.dragSize.height += 40 / self.scale
        })
    }
    var button_moveDown: some View {
        getButton(imageName: "arrow.down", action: {
            self.dragSize.height -= 40 / self.scale
        })
    }
    var button_moveLeft: some View {
        getButton(imageName: "arrow.left", action: {
            self.dragSize.width += 80 / self.scale
        })
    }
    var button_moveRight: some View {
        getButton(imageName: "arrow.right", action: {
            self.dragSize.width -= 80 / self.scale
        })
    }
    
    var button_scaleUp: some View {
        getButton(imageName: "plus", action: {
            self.scale += 0.2
        })
    }
    var button_scaleDown: some View {
        getButton(imageName: "minus", action: {
            self.scale -= 0.2
        })
    }
}


//struct CreatePodMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePodMapView(viewModel: InstallationViewModel(installation: Installation()), floorPlanIndex: 0, showImagePicker: false)
//    }
//}
