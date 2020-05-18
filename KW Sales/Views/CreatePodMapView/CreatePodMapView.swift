//
//  CreatePodMapView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct CreatePodMapView: View {
    var viewModel: InstallationViewModel
    var floorPlanIndex: Int
    
    @State var showImagePicker: Bool = false
    @State var image: Image?
    @State private var isShowingAlert = false
    @State var isLoading = false
    @State var showingActionSheet = false
    @State private var position = CGSize.zero
    //    @State var podNodes: [PodNodeView] = []
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    @State var pods: [Pod] = []
    @State var isPlacingPod: Bool = false
    @State var nextPodType: PodType = .vertical_hallway
    @State var podIndex = 0
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        VStack {
            
            
            ZStack {
                //                self.image != nil ? self.image?.resizable() : Image("blankImage").resizable()
                self.image != nil ? self.image?.resizable() : Image("blankImage").resizable()
                self.podGroup
                if isLoading {
                    ActivityIndicator()
                }
                
            }
            .coordinateSpace(name: "custom")
            .overlay(podPlacementGesture)
            .scaledToFit()
            .animation(.none)
            .scaleEffect(self.scale)
            .offset(self.dragSize)
                
                
                
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.image = Image(uiImage: image)
                        .resizable()
                    self.isLoading = true
                    self.viewModel.floorPlanImages.append(Image(uiImage: image))
                    self.viewModel.uploadFloorPlan(image: image) { success in
                        if success {
                            self.isLoading = false
                        } else {
                            self.isLoading = false
                            print("error uploading image")
                        }
                    }
                }
            }
            
            Spacer()
            moveAndScaleButtons
            actionSheetButton
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(title: Text("Successfully Saved POD Map"))
        }
        .onAppear() {
            if self.image == nil {
                self.showImagePicker.toggle()
            }
            self.getPods()
        }
        .navigationBarItems(trailing: saveButton)
    }
    
    var podPlacementGesture: some View {
        
        if self.isPlacingPod {
            return AnyView(GeometryReader {geo in
                Color.clear.contentShape(Rectangle())
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named(AnyHashable("custom")))
            .onChanged({ (value) in
                print(value.location)
                self.addPod(pod: Pod(podType: self.nextPodType, position: value.location))
            })
            ))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var podGroup: some View {
        if pods.count > 0 {
            return AnyView(
                Group {
                    ForEach(0..<pods.count, id: \.self) { index in
                        PodNodeView(podType: self.pods[index].podType, pos: self.pods[index].position)
                            //                            .scaleEffect(1 / self.scale)
                            .onTapGesture {
                                if !self.isPlacingPod {
                                    self.pods.remove(at: index)
                                }
                        }
                    }
                }
            )
        }
        else {
            return AnyView(EmptyView())
        }
    }
    
    var saveButton: some View {
        Button(action: {
            self.isShowingAlert = true
            print("pressed save")
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
                        self.isPlacingPod = true
                    }),
                    .default(Text("Corner POD"), action: {
                        self.nextPodType = .corner
                        self.isPlacingPod = true
                    }),
                    .default(Text("Horizontal Hallway POD"), action: {
                        self.nextPodType = .horizontal_hallway
                        self.isPlacingPod = true
                    }),
                    .default(Text("Vertical Hallway POD"), action: {
                        self.nextPodType = .vertical_hallway
                        self.isPlacingPod = true
                    }),
                    .default(Text("Delete PODs"), action: {
                        self.isPlacingPod = false
                    }),
                    .cancel()])
        })
    }
    
    func getPods() {
        let key = floorPlanIndex >= viewModel.installation.floorPlanUrls.count ? "" : viewModel.installation.floorPlanUrls[floorPlanIndex]
        self.pods = viewModel.installation.pods[key] ?? []
    }
    
    func addPod(pod: Pod) {
        if isLoading {
            return
        }
        self.pods.append(pod)
//        self.isPlacingPod = false
        
        //add to implementation plan
        let key = self.viewModel.installation.floorPlanUrls[floorPlanIndex]
        if self.viewModel.installation.pods.keys.contains(key) {
            self.viewModel.installation.pods[key]?.append(pod)
        } else {
            self.viewModel.installation.pods[key] = [pod]
        }
    }
}

struct CreatePodMapView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePodMapView(viewModel: InstallationViewModel(installation: Installation()), floorPlanIndex: 0)
    }
}

extension CreatePodMapView {
    
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
            self.dragSize.width += 40 / self.scale
        })
    }
    var button_moveRight: some View {
        getButton(imageName: "arrow.right", action: {
            self.dragSize.width -= 40 / self.scale
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


