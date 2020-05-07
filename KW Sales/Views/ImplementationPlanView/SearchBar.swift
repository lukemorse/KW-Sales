//
//  AddressSearchBar.swift
//  KW Sales
//
//  Created by Luke Morse on 5/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MapKit
import Combine
import Firebase

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var didSelect: Bool
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        @Binding var didSelect: Bool
        
        init(text: Binding<String>, didSelect: Binding<Bool>) {
            _text = text
            _didSelect = didSelect
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            didSelect = false
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, didSelect: $didSelect)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

// MARK: - LocationSearchService
class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = ""
    var completer: MKLocalSearchCompleter
    @Published var completions: [MKLocalSearchCompletion] = []
    @Published var selectedAddress: GeoPoint = GeoPoint(latitude: 0, longitude: 0)
    var cancellable: AnyCancellable?
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
}

extension MKLocalSearchCompletion: Identifiable {}

struct AddressSearchBar: View {
    let labelText: String
    @State var didSelect = false
    @ObservedObject var locationSearchService: LocationSearchService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(labelText)
                .font(.headline)
            SearchBar(text: $locationSearchService.searchQuery, didSelect: $didSelect)
            
            if didSelect && !locationSearchService.completions.isEmpty {
                VStack {
                    Text(locationSearchService.completions[0].title)
                    Text(locationSearchService.completions[0].subtitle)
                }
            } else {
                List(locationSearchService.completions) { completion in
                    VStack(alignment: .leading) {
                        Text(completion.title)
                        Button(action: {
                            self.onSelectAddress(address: completion.subtitle)
                        }) {
                            Text(completion.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        //                    Text(completion.subtitle)
                        //                        .font(.subheadline)
                        //                        .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    func onSelectAddress(address: String) {
        self.didSelect = true
        self.locationSearchService.searchQuery = address
        self.locationSearchService.completions = []
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("error finding location")
                    return
            }
            self.locationSearchService.selectedAddress = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}

struct AddressSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        AddressSearchBar(labelText: "School Address", locationSearchService: LocationSearchService())
    }
}
