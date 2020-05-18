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
    
    var body: some View {
        listView
            .onAppear() {
                if(self.viewModel.districts.isEmpty) {
                    self.viewModel.getDistricts()
                    self.viewModel.fetchTeams()
                }
                
                
        }
    }
    
    var listView: some View {
        if self.viewModel.districts.count > 0 {
            return AnyView(List {
                
                //                addDistrictButton
                
                ForEach(0..<viewModel.districts.count, id: \.self) { index in
                    NavigationLink(self.viewModel.districts[index].districtName, destination: AddDistrictView(district: self.$viewModel.districts[index], districtIndex: index))
                }})
        }
        return AnyView(EmptyView())
        //        return AnyView(List{addDistrictButton})
    }
    
    //    var addDistrictButton: some View {
    //        NavigationLink(destination: AddDistrictView(with: District())) {
    //            Text("Add District")
    //                .frame(maxWidth: .infinity)
    //                .padding()
    //                .foregroundColor(Color.white)
    //                .background(Color.blue)
    //                .multilineTextAlignment(.center)
    //                .cornerRadius(5)
    //                .shadow(radius: 5)
    //        }
    //        .buttonStyle(PlainButtonStyle())
    //    }
}

struct EditDistrictTest_Previews: PreviewProvider {
    static var previews: some View {
        EditDistrictsView()
    }
}
