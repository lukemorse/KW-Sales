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
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var locationSearchService = LocationSearchService()
    @State private var numPodsNeeded = 0
    @State private var numPodsString = ""
    @State private var isShowingAlert = false
    @State private var isFieldsIncomplete = false
    @State private var addDistrictSuccess = false
    @State private var addDistrictFail = false
    @Binding var district: District?
    let districtIndex: Int
    let newFlag: Bool
    
    init(districtIndex: Int, newFlag: Bool) {
        self.districtIndex = districtIndex
        self._district = .constant(nil)
        self.newFlag = newFlag
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
            
            NavigationLink(destination: ImplementationPlanView(district: self.mainViewModel.getDistrict(index: districtIndex), districtIndex: self.districtIndex)
            ) {
                Text("Implementation Plan")
                    .foregroundColor(Color.blue)
            }
            
            sendPodOrderButton
        }
            
        .navigationBarTitle(newFlag ? "New District" : "Edit District")
        .navigationBarItems(trailing: saveButton)
            //        .navigationBarItems(leading: Image("Logo"), trailing: saveButton)
            
            .alert(isPresented: self.$isShowingAlert) {
                if self.addDistrictSuccess {
                    return Alert(title: Text("Successfully Uploaded District Data"))
                } else if self.addDistrictFail {
                    return Alert(title: Text("Failed to Upload District Data"))
                } else if self.isFieldsIncomplete {
                    return Alert(title: Text("Please enter District Name"))
                } else {
                    return Alert(title: Text("Something went wrong"))
                }
        }
        .onAppear() {
            if self.mainViewModel.getDistrict(index: self.districtIndex).numPodsNeeded.wrappedValue != 0 {
                self.numPodsNeeded = self.mainViewModel.getDistrict(index: self.districtIndex).numPodsNeeded.wrappedValue
                self.numPodsString = "\(self.numPodsNeeded)"
            }
        }
    }
    
    //MARK: - Buttons
    var sendPodOrderButton: some View {
        //Button is red until email is valid
        let district = self.mainViewModel.getDistrict(index: districtIndex).wrappedValue
        return SendPodOrderButtonView(numPods: district.numPodsNeeded , email: district.districtEmail , textColor: validateEmail(enteredEmail: district.districtEmail ) ? Color.green : Color.red)
    }
    
    var saveButton: some View {
        Button(action: {
            if self.mainViewModel.getDistrict(index: self.districtIndex).districtName.wrappedValue.isEmpty {
                self.isFieldsIncomplete = true
                self.isShowingAlert = true
                return
            }
            self.mainViewModel.uploadDistrict(districtIndex: self.districtIndex) { success in
                if success {
                    self.addDistrictSuccess = true
                    self.isShowingAlert = true
                } else {
                    self.addDistrictFail = true
                    self.isShowingAlert = true
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
                    self.numPodsNeeded = Int(filtered) ?? 0
                    if self.numPodsNeeded != self.mainViewModel.getDistrict(index: self.districtIndex).numPodsNeeded.wrappedValue {
                        self.mainViewModel.setNumPods(numPods: self.numPodsNeeded, districtIndex: self.districtIndex)
                    }
            }
            .padding(.all)
        }
    }
    
    var startDatePicker: some View {
        VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: self.mainViewModel.getDistrict(index: self.districtIndex).startDate, displayedComponents: .date) {
                Text("")
            }
        }
    }
    
    var districtNameField: some View {
        VStack(alignment: .leading) {
            Text("District Name")
                .font(.headline)
            TextField("Enter District Name", text: self.mainViewModel.getDistrict(index: self.districtIndex).districtName)
                .padding(.all)
        }
    }
    
    var districtAddressField: some View {
        VStack(alignment: .leading) {
            Text("District Office Address")
                .font(.headline)
            TextField("Enter District Office Address", text: self.mainViewModel.getDistrict(index: self.districtIndex).districtOfficeAddress)
                .padding(.all)
        }
    }
    
    var numPreKSchoolsPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of Pre-K Schools")
                .font(.headline)
            
            Picker(selection:
                self.mainViewModel.getDistrict(index: self.districtIndex).numPreKSchools,
                   
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
                self.mainViewModel.getDistrict(index: self.districtIndex).numElementarySchools,
                   
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
                self.mainViewModel.getDistrict(index: self.districtIndex).numMiddleSchools,
                   
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
                self.mainViewModel.getDistrict(index: self.districtIndex).numHighSchools,
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
            TextField("Enter District Contact Name", text: self.mainViewModel.getDistrict(index: self.districtIndex).districtContactPerson)
                .padding(.all)
        }
    }
    
    var districtEmailField: some View {
        VStack(alignment: .leading) {
            Text("District Email")
                .font(.headline)
            TextField("Enter District Email", text: self.mainViewModel.getDistrict(index: self.districtIndex).districtEmail)
                .padding(.all)
        }
    }
    
    var districtPhoneField: some View {
        VStack(alignment: .leading) {
            Text("District Phone Number")
                .font(.headline)
            TextField("Enter District Phone Number", text: self.mainViewModel.getDistrict(index: self.districtIndex).districtPhoneNumber)
                .padding(.all)
        }
    }
    
    var readyToInstallToggle: some View {
        Toggle(isOn: self.mainViewModel.getDistrict(index: self.districtIndex).readyToInstall)  {
            Text("Ready To Install")
        }
    }
    
    func formIsEmpty() -> Bool {
        let district = self.mainViewModel.getDistrict(index: self.districtIndex).wrappedValue
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
