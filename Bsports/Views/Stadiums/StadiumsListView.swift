import SwiftUI

struct StadiumsListView: View {
    @StateObject private var viewModel = StadiumsListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fanBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LottieView.loading()
                        .frame(width: 60, height: 60)
                } else if filteredStadiums.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "building.2")
                            .font(.system(size: 60))
                            .foregroundColor(.fanGrayText)
                        Text("No stadiums found")
                            .font(.montserratHeadline)
                            .foregroundColor(.fanTextPrimary)
                        Text("Try a different search")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredStadiums) { stadium in
                                NavigationLink(destination: StadiumDetailView(stadium: stadium)) {
                                    StadiumCardView(stadium: stadium)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Stadiums")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search stadiums")
            .searchBarTextColor()
            .task {
                await viewModel.loadStadiums()
            }
        }
    }
    
    private var filteredStadiums: [Stadium] {
        if searchText.isEmpty {
            return viewModel.stadiums
        }
        return viewModel.stadiums.filter { stadium in
            stadium.name.localizedCaseInsensitiveContains(searchText) ||
            (stadium.city?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (stadium.country?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
}

#Preview {
    StadiumsListView()
}
