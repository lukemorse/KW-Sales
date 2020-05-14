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
                                self.getNavLink(index: row * 2 + column, image: array[row][column], width: geometry.size.width / 2.5)
                            }
                        }.padding()
                    }
                }
            }
        }
        .onAppear() {
            self.selection = nil
        }
    }
    
    func getImageArrayWithPlusSign() -> [Image] {
        return viewModel.floorPlanImages + [Image(systemName: "plus")]
    }
    
    func getNavLink(index: Int, image: Image, width: CGFloat) -> some View {
        NavigationLink(destination: CreatePodMapView(image: index >= self.viewModel.floorPlanImages.count ? nil : self.viewModel.floorPlanImages[index], viewModel: self.viewModel, floorPlanIndex: index)) {
            image
            .resizable()
            .scaledToFill()
            .border(Color.black)
            .frame(width: width)
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
    }
}

struct PodMapMasterView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = InstallationViewModel(installation: Installation(), teams: [])
        viewModel.floorPlanImages.append(Image(systemName: "plus"))
        viewModel.floorPlanImages.append(Image(systemName: "plus"))
        return
            NavigationView {
                PodMapMasterView(viewModel: viewModel)
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
