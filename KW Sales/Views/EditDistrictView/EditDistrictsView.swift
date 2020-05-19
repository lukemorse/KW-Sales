//
//  EditDistrictTest.swift
//  KW Sales
//
//  Created by Luke Morse on 5/14/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase

struct EditDistrictsView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var addedDistrict: Binding<District>?
    @State private var addedDistrictIndex = 0
    @State private var shouldNavigate = false
    
    var body: some View {
        listView
            .onAppear() {
                if(self.viewModel.districts.isEmpty) {
                    self.viewModel.fetchDistricts()
                    self.viewModel.fetchTeams()
                }
        }
    }
    
    var listView: some View {
            AnyView(List {
                addDistrictButton
                if self.viewModel.districts.count > 0 {
                    ForEach(0..<viewModel.districts.count, id: \.self) { index in
                        NavigationLink(self.viewModel.districts[index].districtName, destination: AddDistrictView(districtIndex: index))
                    }
                }
                navLink
            })
        
        //        return AnyView(EmptyView())
        //        return AnyView(List{addDistrictButton})
    }
    
    //        var addDistrictButton: some View {
    //            let index = self.viewModel.districts.count
    //            return NavigationLink(destination: AddDistrictView(district: self.viewModel.addDistrict(), districtIndex: index)) {
    //                Text("Add District")
    //                    .frame(maxWidth: .infinity)
    //                    .padding()
    //                    .foregroundColor(Color.white)
    //                    .background(Color.blue)
    //                    .multilineTextAlignment(.center)
    //                    .cornerRadius(5)
    //                    .shadow(radius: 5)
    //            }
    //            .buttonStyle(PlainButtonStyle())
    //        }
    
    var navLink: some View {
        NavigationLink(destination: AddDistrictView( districtIndex: self.addedDistrictIndex), isActive: self.$shouldNavigate) {
            Text("").hidden()
        }
    }
    
    var addDistrictButton: some View {
        
        return Button(action: {
            self.addedDistrictIndex = self.viewModel.districts.count
            self.addedDistrict = self.viewModel.addDistrict()
            self.shouldNavigate = true
            
        }) {
            Text("Add District")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .multilineTextAlignment(.center)
                .cornerRadius(5)
                .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditDistrictTest_Previews: PreviewProvider {
    static var previews: some View {
        EditDistrictsView().environmentObject(MainViewModel())
    }
}
