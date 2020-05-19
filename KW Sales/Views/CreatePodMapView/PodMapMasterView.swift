//
//  PodMapMasterView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodMapMasterView: View {
    @ObservedObject var viewModel: InstallationViewModel
    @State var selectedImageIndex = 0
    @State var selection: Int?
    
    var body : some View {
        let array = self.getImageArrayWithPlusSign().chunked(into: 2)
        return GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(0..<array.count, id: \.self) { row in // create number of rows
                        HStack {
                            ForEach(0..<array[row].count, id: \.self) { column in // create 2 columns
                                self.getNavLink(index: row * 2 + column, image: array[row][column], size: geometry.size)
                            }
                        }.padding()
                    }
                }
            }
        }
        .onAppear() {
            self.selection = nil
        }
        .navigationBarItems(trailing: saveButton)
    }
    
    var saveButton: some View {
        Text("Save")
            .foregroundColor(.blue)
    }
    
    func getImageArrayWithPlusSign() -> [Image] {
        return viewModel.floorPlanImages + [Image(systemName: "plus")]
    }
    
    func getNavLink(index: Int, image: Image, size: CGSize) -> some View {
        NavigationLink(destination: CreatePodMapView(viewModel: self.viewModel, floorPlanIndex: index, image: index >= self.viewModel.floorPlanImages.count ? nil : self.viewModel.floorPlanImages[index])) {
            if index == viewModel.floorPlanImages.count {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.5)
                    .foregroundColor(Color.blue)
                    .border(Color.black)
                    .frame(width: size.width / 2.5, height: size.height / 2.5)
            } else {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .border(Color.black)
                    .frame(width: size.width / 2.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
    }
}

struct PodMapMasterView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = InstallationViewModel(installation: Installation())
        viewModel.floorPlanImages.append(Image(systemName: "plus"))
        viewModel.floorPlanImages.append(Image(systemName: "plus"))
        return
            NavigationView {
//                PodMapMasterView(viewModel: viewModel)
                Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(0.5)
                .foregroundColor(Color.blue)
                .border(Color.black)
                .frame(width: 200, height: 200)
        }
    }
}

extension View {
    func inExpandingRectangle() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
