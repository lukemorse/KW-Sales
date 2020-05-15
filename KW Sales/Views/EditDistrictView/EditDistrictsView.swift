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
    @ObservedObject var viewModel = ViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        listView
            .onAppear() {
                self.viewModel.getDistricts()
        }
    }
    
    var listView: some View {
        if self.viewModel.districts.count > 0 {
            return AnyView(List {
                
                addDistrictButton
                
                ForEach(0..<viewModel.districts.count, id: \.self) { index in
                    NavigationLink(self.viewModel.districts[index].districtName, destination: AddDistrictView(with: self.viewModel.districts[index]))
                }})
        }
        return AnyView(Text("No schools found"))
    }
    
    var addDistrictButton: some View {
        NavigationLink(destination: AddDistrictView(with: District())) {
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
    
    class ViewModel: ObservableObject {
        @Published var districts: [District] = []
        
        func getDistricts() {
            districts = []
            Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        do {
                            let district = try FirestoreDecoder().decode(District.self, from: document.data())
                            self.districts.append(district)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
    }
}

struct EditDistrictTest_Previews: PreviewProvider {
    static var previews: some View {
        EditDistrictsView()
    }
}
