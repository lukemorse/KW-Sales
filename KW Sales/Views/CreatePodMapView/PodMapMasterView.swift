//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct PodMapMasterView: View, Equatable {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: InstallationViewModel
    @State var selection: Int?
    @State var showImagePicker: Bool = false
    @State var isLoading = false
    
    var body : some View {
        let urlArray = viewModel.installation.floorPlanUrls.chunked(into: 2)
        return ZStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(0..<urlArray.count, id: \.self) { row in // create number of rows
                            HStack {
                                ForEach(0..<urlArray[row].count, id: \.self) { column in // create 2 columns
                                    self.getNavLink(index: row * 2 + column, size: geometry.size)
                                }
                            }.padding()
                        }
                    }
                }
                .frame(width: geometry.size.width)
            }
            if isLoading {
                ActivityIndicator()
            }
        }
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.isLoading = true
                self.viewModel.uploadFloorPlan(image: image) { (success, urlString) in
                    if success {
                        self.isLoading = false
                        self.showImagePicker = true
                    } else {
                        self.isLoading = false
                        print("error uploading image")
                    }
                }
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            self.showImagePicker = true
        }) {
            Text("New")
        }
    }
    
    func getNavLink(index: Int, size: CGSize) -> some View {
        let asyncImage = AsyncImage(url: URL(string: self.viewModel.installation.floorPlanUrls[index])!, cache: self.cache, placeholder: Text("Loading...").padding(), configuration:
        {$0.resizable()})
        
        let podMapViewModel = PodMapViewModel(installationDocRef: viewModel.installDocRef, url: URL(string: self.viewModel.installation.floorPlanUrls[index])!)
        
        return NavigationLink(destination: PodMapView(viewModel: podMapViewModel, floorPlanIndex: index).environmentObject(self.viewModel), tag: index, selection: $selection) {
            asyncImage
                .aspectRatio(contentMode: .fit)
                .border(Color.black)
                .frame(width: size.width / 2.5)
                .onTapGesture {
                    self.selection = index
            }
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.selection == rhs.selection
    }
}


