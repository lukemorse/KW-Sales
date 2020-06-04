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
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var locationSearchService: LocationSearchService
    @State private var numPodsString = ""
    @State private var alertItem: AlertItem?
    
    let districtID: String
    let newFlag: Bool
    let uploadDistrictHandler: (String, @escaping (Bool) -> ()) -> ()
    
    init(districtID: String, newFlag: Bool,
         uploadDistrictHandler: @escaping (String, @escaping (Bool) -> ()) -> ()) {
        self.newFlag = newFlag
        self.districtID = districtID
        self.uploadDistrictHandler = uploadDistrictHandler
    }
    
    var body: some View {
        VStack {
            Form {
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
                        phoneNumberField
                        addressPickerNavLink
                    }
                }
                Section {
                    readyToInstallToggle
                }
                Section {
                    implementationPlanNavLink
                    sendPodOrderButton
                }
//                Section {
                    saveButton
//                }
//                .background(Color.green)
            }
        }
        .keyboardAdaptive()
            
        .navigationBarTitle(Text(newFlag ? "New District" : "Edit District"), displayMode: .inline)
//        .navigationBarItems(trailing: saveButton)
        .alert(item: $alertItem) {alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
//        .onAppear() {
//            if self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.numPodsNeeded != 0 {
//                self.numPodsString = "\(self.mainViewModel.getDistrict(id: self.districtID).numPodsNeeded)"
//            }
//        }
        //        .padding(.bottom, keyboard.currentHeight)
    }
    
    //MARK: - Buttons
    var sendPodOrderButton: some View {
        //Button is red until email is valid
        let district = self.mainViewModel.getDistrict(id: self.districtID).wrappedValue
        return SendPodOrderButtonView(numPods: district.numPodsNeeded , email: district.districtEmail , textColor: validateEmail(enteredEmail: district.districtEmail ) ? Color.green : Color.red)
    }
    
    var implementationPlanNavLink: some View {
        NavigationLink(destination: ImplementationPlanView(districtId: self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.districtID)
        ) {
            Text("📋 Implementation Plan")
                .font(.title)
                .foregroundColor(Color.blue)
                .padding()
        }
    }
    
    var saveButton: some View {
        Button(action: {
            //show warning if district name is empty
            if self.self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.districtName.isEmpty {
                self.alertItem = AlertItem(title: Text("Enter District Name"), message: nil, dismissButton: .cancel(Text("OK")))
                return
            }
            
            //filter out any alpha chars in numPodsString
            let filtered = self.numPodsString.filter {"0123456789".contains($0)}
            self.mainViewModel.setNumPods(numPods: Int(filtered) ?? 0, districtID: self.districtID)
            
                //upload district
            self.uploadDistrictHandler(self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.districtID) { success in
                if success {
                    self.alertItem = AlertItem(title: Text("Successfully Uploaded District Data"), message: nil, dismissButton: .cancel(Text("OK")))
                } else {
                    self.alertItem = AlertItem(title: Text("Error Uploading District"), message: nil, dismissButton: .cancel(Text("OK")))
                }
            }
        }) {
            HStack {
                Spacer()
                Text("💾  Save")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding()
                Spacer()
            }.background(Color.green)
            .cornerRadius(10)
        }
    }
}

extension EditDistrictDetailView {
    // MARK: - Form Items
    
    var addressPickerNavLink: some View {
        NavigationLink(destination: AddressPicker(locationSearchService: locationSearchService, label: "District Office Address", callback: { address in
            self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.districtOfficeAddress = address
            
        })) {
            HStack {
                Text("🏢 District Office Address")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding()
                Spacer()
                Text(self.mainViewModel.getDistrict(id: self.districtID).wrappedValue.districtOfficeAddress)
                    .foregroundColor(Color.gray)
            }
        }
    }
    
    var numPodField: some View {
        VStack(alignment: .leading) {
            Text("Number of PODs Needed")
                .font(.headline)
            TextField("Enter Number of PODs", text: self.$numPodsString)
                .keyboardType(.numberPad)
            .padding(.all)
        }
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: self.mainViewModel.getDistrict(id: self.districtID).startDate, displayedComponents: .date) {
                Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: self.mainViewModel.getDistrict(id: self.districtID).districtName)
                .padding(.all)
        }
    }
    
    var districtAddressField: some View {
        VStack(alignment: .leading) {
            Text("District Office Address")
                .font(.headline)
            TextField("Enter District Office Address", text: self.mainViewModel.getDistrict(id: self.districtID).districtOfficeAddress)
                .padding(.all)
        }
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                self.mainViewModel.getDistrict(id: self.districtID).numPreKSchools,
                   
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
                self.mainViewModel.getDistrict(id: self.districtID).numElementarySchools,
                   
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
                self.mainViewModel.getDistrict(id: self.districtID).numMiddleSchools,
                   
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
                self.mainViewModel.getDistrict(id: self.districtID).numHighSchools,
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
            TextField("Enter District Contact Name", text: self.mainViewModel.getDistrict(id: self.districtID).districtContactPerson)
                .padding(.all)
        }
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: self.mainViewModel.getDistrict(id: self.districtID).districtEmail)
                .padding(.all)
        }
    }
    
    var phoneNumberField: some View {
        VStack(alignment: .leading) {
        Text("District Phone Number")
            .font(.headline)
            PhoneNumberField(phoneNumber: self.mainViewModel.getDistrict(id: self.districtID).districtPhoneNumber)
            .padding()
        }
    }
    
//    var districtPhoneField: some View {
//        VStack(alignment: .leading) {
//            Text("District Phone Number")
//                .font(.headline)
//            TextField("Enter District Phone Number", text: self.mainViewModel.getDistrict(id: self.districtID).districtPhoneNumber)
//                .padding(.all)
//        }
//    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: self.mainViewModel.getDistrict(id: self.districtID).readyToInstall)  {
            Text("Ready To Install")
            .font(.title)
            .padding()
        }
    }
    
    func formIsEmpty() -> Bool {
        let district = self.mainViewModel.getDistrict(id: self.districtID).wrappedValue
        return district.districtContactPerson.isEmpty ||
            district.districtEmail.isEmpty ||
            district.districtPhoneNumber.isEmpty ||
            district.districtOfficeAddress.isEmpty
    }
}



struct EditDistrictDetailView_Previews: PreviewProvider {
    static func handler(id: String, completion: @escaping (_ flag:Bool) -> ()) {}
    static var previews: some View {
        
        let mvm = MainViewModel()
        var district = District()
        district.districtID = "123"
        mvm.districts = [district]
        
        return NavigationView {
            EditDistrictDetailView(districtID: "123", newFlag: true, uploadDistrictHandler: handler)
                .environmentObject(mvm)
            .environmentObject(LocationSearchService())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
