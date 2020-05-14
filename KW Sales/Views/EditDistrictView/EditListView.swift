//
//  EditListView.swift
//  KW Sales
//
//  Created by Luke Morse on 5/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct EditListView: View {
    @ObservedObject var viewModel = EditListViewModel()
    @State var selectedDistrict: District?
    @State var isShowingSheet = false
    
    var body: some View {
        listView
            .onAppear() {
                self.viewModel.getDistricts()
        }
    }
    
    var listView : some View {
        if self.viewModel.districts.count > 0 {
            return AnyView(List {
                ForEach(0..<self.viewModel.districts.count, id: \.self) {index in
                    NavigationLink(self.viewModel.districts[index].districtName, destination:
                        AddDistrictView(with: self.viewModel.districts[index]))}
                }
            )
        }
        return AnyView(List {
            Text("No Schools found")
        })
    }
}

struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditListView()
        }
    }
}
