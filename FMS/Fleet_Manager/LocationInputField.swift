//
//  LocationInputField.swift
//  FMS
//
//  Created by Aastik Mehta on 18/02/25.
//


import SwiftUI

struct LocationInputField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    @ObservedObject var searchViewModel: LocationSearchViewModel

    var placeholder: String

    var body: some View {
        VStack(spacing: 0) {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focused($isFocused)
                .onChange(of: text) {
                    if text.count > 2 {
                        searchViewModel.search(query: text)
                    } else {
                        searchViewModel.searchResults = []
                    }
                }

            if isFocused && !searchViewModel.searchResults.isEmpty {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(searchViewModel.searchResults, id: \.title) { result in
                            Text(result.title)
                                .padding()
                                .frame(height: 50) // Matches text field height
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .onTapGesture {
                                    text = result.title
                                    isFocused = false // Hide keyboard
                                    searchViewModel.searchResults = [] // Hide dropdown
                                }
                        }
                    }
                }
                .frame(height: min(CGFloat(searchViewModel.searchResults.count) * 50, 200))
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
        }
    }
}
