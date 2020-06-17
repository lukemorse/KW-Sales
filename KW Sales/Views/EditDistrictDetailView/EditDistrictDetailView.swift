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
    @ObservedObject var viewModel: EditDistrictDetailViewModel
    @State private var numPodsString = ""
    @State private var alertItem: AlertItem?
    let newFlag: Bool
    
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
                    saveButton
            }
        .enableKeyboardOffset()
        }
            
        .navigationBarTitle(Text(newFlag ? "New District" : "Edit District"), displayMode: .inline)
//        .navigationBarItems(trailing: saveButton)
        .alert(item: $alertItem) {alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
    //MARK: - Buttons
    var sendPodOrderButton: some View {
        //Button is red until email is valid
        let district = self.viewModel.district
        return SendPodOrderButtonView(numPods: district.numPodsNeeded , email: district.districtEmail , textColor: validateEmail(enteredEmail: district.districtEmail ) ? Color.green : Color.red)
    }
    
    var implementationPlanNavLink: some View {
        let subCollectionRef = Firestore.firestore().collection(Constants.kDistrictCollection).document(viewModel.district.districtID).collection(Constants.kInstallSubCollection)
        return AnyView(NavigationLink(destination:
            ImplementationPlanView(viewModel: ImplementationPlanViewModel(collectionRef: subCollectionRef))
        ) {
            Text("📋 Implementation Plan")
                .font(.title)
                .foregroundColor(Color.blue)
                .padding()
        })
    }
    
    var saveButton: some View {
        Button(action: {
            //show warning if district name is empty
            if self.viewModel.district.districtName.isEmpty {
                self.alertItem = AlertItem(title: Text("Enter District Name"), message: nil, dismissButton: .cancel(Text("OK")))
                return
            }
            
            //filter out any alpha chars in numPodsString
            let filtered = self.numPodsString.filter {"0123456789".contains($0)}
            if let numPods = Int(filtered) {
                self.viewModel.district.numPodsNeeded = numPods
            }

                //upload district
            self.viewModel.uploadDistrict() { success in
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
        NavigationLink(destination: AddressPicker(label: "District Office Address", callback: { address in
            self.viewModel.district.districtOfficeAddress = address
            
        })) {
            HStack {
                Text("🏢 District Office Address")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding()
                Spacer()
                Text(self.viewModel.district.districtOfficeAddress)
                    .foregroundColor(Color.gray)
            }
        }
    }
    
    var numPodField: some View {
        VStack(alignment: .leading) {
            Text("Number of PODs Needed")
                .font(.headline)
            TextField("Enter Number of PODs", text: self.$numPodsString)
                .hideKeyboardOnTap()
                .keyboardType(.numberPad)
            .padding(.all)
        }
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: self.$viewModel.district.startDate, displayedComponents: .date) {
                Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: self.$viewModel.district.districtName)
                .hideKeyboardOnTap()
                .padding(.all)
        }
    }
    
    var districtAddressField: some View {
        VStack(alignment: .leading) {
            Text("District Office Address")
                .font(.headline)
            TextField("Enter District Office Address", text: self.$viewModel.district.districtOfficeAddress)
                .hideKeyboardOnTap()
                .padding(.all)
        }
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                self.$viewModel.district.numPreKSchools,
                   
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
                self.$viewModel.district.numElementarySchools,
                   
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
                self.$viewModel.district.numMiddleSchools,
                   
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
                self.$viewModel.district.numHighSchools,
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
            TextField("Enter District Contact Name", text: self.$viewModel.district.districtContactPerson)
                .hideKeyboardOnTap()
                .padding(.all)
        }
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: self.$viewModel.district.districtEmail)
                .hideKeyboardOnTap()
                .padding(.all)
        }
    }
    
    var phoneNumberField: some View {
        VStack(alignment: .leading) {
        Text("District Phone Number")
            .font(.headline)
            PhoneNumberField(phoneNumber: self.$viewModel.district.districtPhoneNumber)
            .padding()
        }
    }
    
//    var districtPhoneField: some View {
//        VStack(alignment: .leading) {
//            Text("District Phone Number")
//                .font(.headline)
//            TextField("Enter District Phone Number", text: self.viewModel.district.districtPhoneNumber)
//                .padding(.all)
//        }
//    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: self.$viewModel.district.readyToInstall)  {
            Text("Ready To Install")
            .font(.title)
            .padding()
        }
    }
    
    func formIsEmpty() -> Bool {
        let district = self.viewModel.district
        return district.districtContactPerson.isEmpty ||
            district.districtEmail.isEmpty ||
            district.districtPhoneNumber.isEmpty ||
            district.districtOfficeAddress.isEmpty
    }
}


//
//struct EditDistrictDetailView_Previews: PreviewProvider {
//    static func handler(id: String, completion: @escaping (_ flag:Bool) -> ()) {}
//    static var previews: some View {
//
//        let mvm = MainViewModel()
//        var district = District()
//        district.districtID = "123"
//        mvm.districts = [district]
//
//        return NavigationView {
//            EditDistrictDetailView(districtID: "123", newFlag: true, uploadDistrictHandler: handler)
//                .environmentObject(mvm)
//            .environmentObject(LocationSearchService())
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
