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
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var locationSearchService =  LocationSearchService()
    
    @State var isExpanded: Bool = true
    @State private var numPods = 0
    @State private var numPodsString = ""
    
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
                
                formItem(with: $viewModel.installation.address, label: "School Address")
                
//                AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
//                    .padding(.bottom, keyboard.currentHeight)
                
                NavigationLink(destination: PodMapMasterView(viewModel: self.viewModel).equatable()) {
                    Text("📍 Pod Maps")
                        .font(.title)
                        .foregroundColor(Color.blue)
                        .padding()
                }
            }
        }
        .onAppear() {
            self.numPods = self.viewModel.installation.numPods
            self.numPodsString = "\(self.numPods)"
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
}

//struct InstallationView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let mvm = MainViewModel()
//        var team1 = Team()
//        team1.name = "Team one"
//        var team2 = Team()
//        team2.name = "Team two"
//        mvm.teams = [team1, team2]
//
//        var installation = Installation()
//        installation.status = .complete
//        installation.schoolName = "Fancy School"
//        installation.team = mvm.teams[1]
//
//
//        return NavigationView {
//            Form {
//                InstallationView(locationSearchService: LocationSearchService(), isExpanded: true).envi
//            }
//        }
//    }
//}

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
