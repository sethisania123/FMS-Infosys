//
//  LocationSearchViewModel.swift
//  FMS
//
//  Created by Aastik Mehta on 18/02/25.
//

import SwiftUI
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    func search(query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.searchResults = []
        } else {
            searchCompleter.queryFragment = query
        }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = Array(completer.results.prefix(4)) // Show only 4 results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching search results: \(error.localizedDescription)")
    }
}
