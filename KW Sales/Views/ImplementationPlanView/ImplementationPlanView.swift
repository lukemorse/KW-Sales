//
//  ImplementationPlanView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/15/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase

struct ImplementationPlanView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel = ViewModel()
    @Binding var district: District
    @State var showSaveAlert = false
    
    var body: some View {
        return Form {
            if viewModel.installations.count > 0 {
                ForEach(0..<viewModel.installations.count, id: \.self) { index in
                    InstallationView(docId: self.viewModel.installations[index].installationID)
//                    InstallationView(docId: self.district.installations[key] ?? "")
                }
            }
            
            Button(action: {
                self.viewModel.installations.append(Installation())
            }) {
                Text("Add School")
                    .foregroundColor(Color.blue)
            }
        }
        .enableKeyboardOffset()
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle("Implementation Plan")
        .alert(isPresented: self.$showSaveAlert) {
            Alert(title: Text("Saved Implementation Plan"))
        }
        .padding(.bottom, 10)
        .onAppear() {
            if let installationsDocRef = self.district.installationsDocRef {
                self.viewModel.fetchInstallations(docRef: installationsDocRef)
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            self.showSaveAlert = true
            print("save")
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var installations: [Installation] = []
        
        public func fetchInstallations(docRef: DocumentReference) {
            docRef.getDocument { (snapshot, error) in
                if let error = error {
                    print(error)
                }
                if let snapshot = snapshot, snapshot.exists {
                    do {
                        let array = try FirebaseDecoder().decode([Installation].self, from: snapshot.data()!)
                        self.installations = array
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}


//struct CreateImplementationPlanListView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let mvm = MainViewModel()
//        var district = District()
//        district.districtID = "123"
//        mvm.districts = [district]
//
//        return
//            NavigationView {
//            ImplementationPlanView(districtId: "123").environmentObject(mvm)
//        }
//    .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
