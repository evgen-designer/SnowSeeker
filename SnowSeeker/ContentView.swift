//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Mac on 13/12/2024.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    @State private var sortOrder = SortOrder.default
    
    enum SortOrder {
        case `default`, alphabetical, country
    }
    
    var filteredResorts: [Resort] {
        let orderedResorts: [Resort]
        
        switch sortOrder {
        case .default:
            orderedResorts = resorts
        case .alphabetical:
            orderedResorts = resorts.sorted { $0.name < $1.name }
        case .country:
            orderedResorts = resorts.sorted { $0.country < $1.country }
        }
        
        if searchText.isEmpty {
            return orderedResorts
        } else {
            return orderedResorts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredResorts) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Menu("Sort") {
                    Button("Default") { sortOrder = .default }
                    Button("Alphabetical") { sortOrder = .alphabetical }
                    Button("By country") { sortOrder = .country }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
