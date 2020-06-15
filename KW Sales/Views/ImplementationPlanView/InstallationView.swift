//
//  CreateImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore
import MapKit

struct InstallationView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel: InstallationViewModel
    @EnvironmentObject var locationSearchService: LocationSearchService
    
    @State var isExpanded: Bool = true
    @State private var numPods = 0
    @State private var numPodsString = ""
    
    init(viewModel: InstallationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Section {
            if !viewModel.installation.schoolName.isEmpty {
                expandedButton
            }
            
            if isExpanded {
                teamPicker
                formItem(with: $viewModel.installation.schoolName, label: "School Name")
                startDatePicker()
                formItem(with: $viewModel.installation.schoolType, label: "School Type")
                formItem(with: $viewModel.installation.numFloors, label: "Number of Floors")
                formItem(with: $viewModel.installation.numRooms, label: "Number of Rooms")
                numPodPicker
                formItem(with: $viewModel.installation.schoolContact, label: "School Contact Person")
                addressPickerNavLink
                podMapNavLink
            }
        }
        .onAppear() {
//            if self.viewModel.installation.schoolName == "" {
//                self.viewModel.fetchInstallation()
//            }
            
            self.numPods = self.viewModel.installation.numPods
            if self.numPods != 0 {
                self.numPodsString = "\(self.numPods)"
            }
        }
    }
    
}

extension InstallationView {
    //Funcs for adding form items
    
    var numPodPicker: some View {
        VStack(alignment: .leading) {
            Text("Number of PODs Needed")
                .font(.headline)
            TextField("Enter Number of PODs", text: self.$numPodsString)
                .hideKeyboardOnTap()
                .keyboardType(.numberPad)
                .onReceive(Just(self.numPodsString)) { newVal in
                    let filtered = newVal.filter {"0123456789".contains($0)}
                    self.numPods = Int(filtered) ?? 0
                    if self.numPods != self.viewModel.installation.numPods {
                        self.viewModel.installation.numPods = self.numPods
                        print(self.viewModel.installation.numPods)
                    }
            }
            .padding(.all)
        }
    }
    
    var expandedButton: some View {
        return HStack {
            Text(viewModel.installation.schoolName)
                .foregroundColor(Color.white)
                .padding()
            Spacer()
                statusIndicator
                    .padding()
                    .font(.title)
                
        }
        .background(Color.blue)
            .onTapGesture {
                self.isExpanded.toggle()
            }
        .cornerRadius(5)
        .shadow(radius: 5)
    }
    
    var statusIndicator: some View {
        if viewModel.installation.status == InstallationStatus.complete {
            return Image(systemName: "checkmark.square.fill")
                .foregroundColor(Color.green)
        } else if viewModel.installation.status == InstallationStatus.inProgress {
            return Image(systemName: "ellipsis.circle.fill")
                .foregroundColor(Color.yellow)
        } else {
            return Image(systemName: "square")
            .foregroundColor(Color.black)
        }
    }
    
    func formItem(with name: Binding<String>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                TextField("Enter " + label, text: name)
                    .hideKeyboardOnTap()
                    .padding([.top, .bottom])
            }
    }
    
    func formItem(with schoolType: Binding<SchoolType>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                Picker(selection: $viewModel.installation.schoolType, label: Text("School Type")) {
                    ForEach(SchoolType.allCases) { school in
                        Text(school.description).tag(school)
                    }
                }
                .padding([.top, .bottom])
            }
    }
    
    var teamPicker: some View {
        return VStack(alignment: .leading) {
            Text("Assigned Team")
                .font(.headline)
            Picker(selection:
                $viewModel.installation.team,
                label:
                Text(""),
                content: {
                    ForEach(self.mainViewModel.teams, id: \.self) { team in
                        Text(team.name).tag(team.name)
                    }
            })}
    }
    
    func formItem(with name: Binding<Int>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                
                Picker(selection: name, label: Text(""), content: {
                    ForEach(0..<50, id: \.self) { idx in
                        Text(String(idx))
                    }
                })
                    .padding([.top, .bottom])
            }
    }
    
    func formItem(with name: Binding<Date>, label: String) -> some View {
        return VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            DatePicker(selection: name, displayedComponents: .date) {
                Text("")
            }
        }
    }
    
    func startDatePicker() -> some View {
        return VStack(alignment: .leading) {
            Text("Start Date")
                .font(.headline)
            
            DatePicker(selection: Binding<Date>(
                get: {self.viewModel.installation.date },
                set: {self.viewModel.installation.date = $0}), displayedComponents: .date) {
                    Text("")
            }
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date)
    }
    
    var addressPickerNavLink: some View {
        NavigationLink(destination: AddressPicker(locationSearchService: locationSearchService, label: "School Address", callback: { address in
            self.viewModel.installation.address = address
            
        })) {
            HStack {
                Text("🏫 School Address")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding()
                Spacer()
                Text(self.viewModel.installation.address)
                    .foregroundColor(Color.gray)
            }
        }
    }
    
    var podMapNavLink: some View {
        NavigationLink(destination: PodMapMasterView(viewModel: self.viewModel).equatable()) {
            Text("📍 Pod Maps")
                .font(.title)
                .foregroundColor(Color.blue)
                .padding()
        }
    }
}

//struct InstallationView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        return NavigationView {
//            Form {
//                InstallationView(viewModel: InstallationViewModel(installation: Installation()), isExpanded: true)
//                    .environmentObject(MainViewModel())
//                    .environmentObject(LocationSearchService())
//            }
//        }
//    .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
