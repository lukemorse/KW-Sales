//
//  LocationTest.swift
//  KW Sales
//
//  Created by Luke Morse on 5/29/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct GreatGrandParentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: GrandParentView()) {
                Text("GrandParentView")
            }
        }
    }
}

struct GrandParentView: View {
    @ObservedObject var locationSearchService = LocationSearchService()
    var body: some View {
        Form {
            AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
            NavigationLink(destination: ParentView()) {
                Text("ParentView")
            }
        }
    }
}

struct ParentView: View {
    var body: some View {
        Form {
            NavigationLink(destination: ChildView()) {
                Text("ChildView")
            }
            NavigationLink(destination: ChildView()) {
                Text("ChildView")
            }
        }
    }
}

struct ChildView: View {
    @ObservedObject var locationSearchService = LocationSearchService()
    var body: some View {
        AddressSearchBar(labelText: "School Address", locationSearchService: locationSearchService)
    }
}

struct LocationTest_Previews: PreviewProvider {
    static var previews: some View {
        GreatGrandParentView()
    }
}
