//
//  CreateImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/13/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct InstallationView: View {
    let index: Int
    
    @ObservedObject var viewModel: InstallationViewModel
    @ObservedObject var locationSearchService: LocationSearchService
    
//    @State var floorPlanIndex = 0
    @State var isExpanded: Bool = true
    
    var body: some View {
        Section {
            if !viewModel.installation.schoolName.isEmpty {
                expandedButton
            }
            
            if isExpanded {
                teamPicker()
                formItem(with: $viewModel.installation.schoolName, label: "School Name")
                startDatePicker()
                formItem(with: $viewModel.installation.schoolType, label: "School Type")
                formItem(with: $viewModel.installation.numFloors, label: "Number of Floors")
                formItem(with: $viewModel.installation.numRooms, label: "Number of Rooms")
                formItem(with: $viewModel.installation.numPods, label: "Number of Pods")
                formItem(with: $viewModel.installation.schoolContact, label: "School Contact Person")
                
                AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
                
                NavigationLink(destination: PodMapMasterView(viewModel: self.viewModel)) {
                    Text("Pod map master")
                }
            }
        }
        .onAppear() {
            self.viewModel.installation.address = self.locationSearchService.selectedAddress
        }
        
    }
    
    func getInstallation() -> Installation {
        return viewModel.installation
    }
    
}

extension InstallationView {
    //Funcs for adding form items
    
    var expandedButton: some View {
        return HStack {
            Spacer()
            Text(viewModel.installation.schoolName)
                .foregroundColor(Color.white)
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
        }
        .onTapGesture {
            self.isExpanded.toggle()
        }
        .background(Color.blue)
        .cornerRadius(5)
        .shadow(radius: 5)
        
    }
    
    func formItem(with name: Binding<String>, label: String) -> some
        View {
            return VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                TextField("Enter " + label, text: name)
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
    
    func teamPicker() -> some View {
        return VStack(alignment: .leading) {
            Text("Assigned Team")
                .font(.headline)
            
            Picker(selection:
                Binding<Int>(
                    get: {self.viewModel.teamIndex},
                    set: {
                        self.viewModel.teamIndex = $0
                        self.viewModel.installation.team = self.viewModel.teams[$0]
                }),
                   
                   label: Text(
                    self.viewModel.teams.count > 0 ? self.viewModel.teams[self.viewModel.teamIndex].name : ""
                ), content: {
                    ForEach(0..<self.viewModel.teams.count, id: \.self) { idx in
                        Text(self.viewModel.teams[idx].name).tag(idx)
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
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(index: 0, viewModel: InstallationViewModel(installation: Installation(), teams: [Team()]), locationSearchService: LocationSearchService(), isExpanded: true)
    }
}

enum SchoolType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case unknown
    case preKSchool
    case elementary
    case middleSchool
    case highSchool
    
    var description: String {
        switch self {
        case .unknown: return "Unknown School Type"
        case .preKSchool: return "Pre K School"
        case .elementary: return "Elementary School"
        case .middleSchool: return "Middle School"
        case .highSchool: return "High School"
        }
    }
}
