//
//  AddDistrictView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import Combine

struct EditDistrictDetailView: View {
    //    @ObservedObject private var keyboard = KeyboardResponder()
    //    @ObservedObject var locationSearchService = LocationSearchService()
    @State private var numPodsString = ""
    @State private var alertItem: AlertItem?
    
    @Binding var district: District
    let newFlag: Bool
    let uploadDistrictHandler: (String, @escaping (Bool) -> ()) -> ()
    
    init(district: Binding<District>, newFlag: Bool,
         uploadDistrictHandler: @escaping (String, @escaping (Bool) -> ()) -> ()) {
        self.newFlag = newFlag
        self._district = district
        self.uploadDistrictHandler = uploadDistrictHandler
    }
    
    var body: some View {
        Form {
            //Uncomment for Mac App
            //            Group {
            //                Button(action: {
            //                    self.viewModel.importCSV()
            //                }) {
            //                    Text("Import CSV")
            //                }
            //            }
            
            Section(header: Text("General")) {
                Group {
                    districtNameField
                    numPodField
                    startDatePicker
                }
            }
            
            Section(header: Text("District Information")){
                Group {
                    numPreKSchoolsPicker
                    numElementarySchoolsPicker
                    numMiddleSchoolsPicker
                    numHighSchoolsPicker
                }
            }
            
            Section(header: Text("Contact Information")) {
                Group {
                    districtContactPersonField
                    districtEmailField
                    districtPhoneField
                    districtAddressField
                    //                    AddressSearchBar(labelText: "District Office Address", locationSearchService: locationSearchService)
                    //                        .padding(.bottom, keyboard.currentHeight)
                }
            }
            
            Section {
                Group {
                    readyToInstallToggle
                }
            }
            
            NavigationLink(destination: ImplementationPlanView(districtId: self.district.districtID)
            ) {
                Text("Implementation Plan")
                    .foregroundColor(Color.blue)
            }
            
            sendPodOrderButton
        }
            
        .navigationBarTitle(Text(newFlag ? "New District" : "Edit District"), displayMode: .inline)
        .navigationBarItems(trailing: saveButton)
        .alert(item: $alertItem) {alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onAppear() {
            if self.district.numPodsNeeded != 0 {
                self.numPodsString = "\(self.district.numPodsNeeded)"
            }
        }
        //        .padding(.bottom, keyboard.currentHeight)
    }
    
    //MARK: - Buttons
    var sendPodOrderButton: some View {
        //Button is red until email is valid
        let district = self.$district.wrappedValue
        return SendPodOrderButtonView(numPods: district.numPodsNeeded , email: district.districtEmail , textColor: validateEmail(enteredEmail: district.districtEmail ) ? Color.green : Color.red)
    }
    
    var saveButton: some View {
        Button(action: {
            if self.district.districtName.isEmpty {
                self.alertItem = AlertItem(title: Text("Enter District Name"), message: nil, dismissButton: .cancel(Text("OK")))
                return
            }
            
            self.uploadDistrictHandler(self.district.districtID) { success in
                if success {
                    self.alertItem = AlertItem(title: Text("Successfully Uploaded District Data"), message: nil, dismissButton: .cancel(Text("OK")))
                } else {
                    self.alertItem = AlertItem(title: Text("Error Uploading District"), message: nil, dismissButton: .cancel(Text("OK")))
                }
            }
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
}

extension EditDistrictDetailView {
    // MARK: - Form Items
    var numPodField: some View {
        VStack(alignment: .leading) {
            Text("Number of PODs Needed")
                .font(.headline)
            TextField("Enter Number of PODs", text: self.$numPodsString)
                .keyboardType(.numberPad)
                .onReceive(Just(self.numPodsString)) { newVal in
                    let filtered = newVal.filter {"0123456789".contains($0)}
                    self.district.numPodsNeeded = Int(filtered) ?? 0
            }
            .padding(.all)
        }
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: self.$district.startDate, displayedComponents: .date) {
                Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: self.$district.districtName)
                .padding(.all)
        }
    }
    
    var districtAddressField: some View {
        VStack(alignment: .leading) {
            Text("District Office Address")
                .font(.headline)
            TextField("Enter District Office Address", text: self.$district.districtOfficeAddress)
                .padding(.all)
        }
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                self.$district.numPreKSchools,
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numElementarySchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Elementary Schools")
                .font(.headline)
            
            Picker(selection:
                self.$district.numElementarySchools,
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numMiddleSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Middle Schools")
                .font(.headline)
            
            Picker(selection:
                self.$district.numMiddleSchools,
                   
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var numHighSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of High Schools")
                .font(.headline)
            
            Picker(selection:
                self.$district.numHighSchools,
                   label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
            })}
    }
    
    var districtContactPersonField: some View {
        VStack(alignment: .leading) {
            Text("District Contact Person")
                .font(.headline)
            TextField("Enter District Contact Name", text: self.$district.districtContactPerson)
                .padding(.all)
        }
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: self.$district.districtEmail)
                .padding(.all)
        }
    }
    
    var districtPhoneField: some View {
        VStack(alignment: .leading) {
            Text("District Phone Number")
                .font(.headline)
            TextField("Enter District Phone Number", text: self.$district.districtPhoneNumber)
                .padding(.all)
        }
    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: self.$district.readyToInstall)  {
            Text("Ready To Install")
        }
    }
    
    func formIsEmpty() -> Bool {
        let district = self.$district.wrappedValue
        return district.districtContactPerson.isEmpty ||
            district.districtEmail.isEmpty ||
            district.districtPhoneNumber.isEmpty ||
            district.districtOfficeAddress.isEmpty
    }
}

//struct AddDistrictView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AddDistrictView(with: District())
//        }
//    }
//}
