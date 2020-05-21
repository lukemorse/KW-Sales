//
//  TestSearchBar.swift
//  KW Sales
//
//  Created by Luke Morse on 5/20/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct GrandParentTestSearchBar: View {
    var locationSearchService = LocationSearchService()
    var body: some View {
        NavigationView {
            VStack {
                AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
                NavigationLink(destination: ParentTestSearchBar()) {
                    Text("ChildView")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ParentTestSearchBar: View {
    var body: some View {
        VStack {
            TestSearchBar(locationSearchService: LocationSearchService())
            TestSearchBar(locationSearchService: LocationSearchService())
            TestSearchBar(locationSearchService: LocationSearchService())
        }
        
    }
}

struct TestSearchBar: View {
    var locationSearchService: LocationSearchService
    var body: some View {
        AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
    }
}

struct TestSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        GrandParentTestSearchBar()
    }
}
