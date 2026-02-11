import SwiftUI

struct StadiumDetailView: View {
    let stadium: Stadium
    @StateObject private var viewModel: StadiumDetailViewModel
    
    init(stadium: Stadium) {
        self.stadium = stadium
        _viewModel = StateObject(wrappedValue: StadiumDetailViewModel(stadiumId: stadium.id))
    }
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Stadium Header
                    VStack(spacing: 16) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.fanPrimaryBlue)
                        
                        Text(stadium.name)
                            .font(.montserratTitle)
                            .foregroundColor(.fanTextPrimary)
                            .multilineTextAlignment(.center)
                        
                        if let city = stadium.city, let country = stadium.country {
                            Text("\(city), \(country)")
                                .font(.montserratBody)
                                .foregroundColor(.fanGrayText)
                        }
                        
                        if let capacity = stadium.capacity {
                            Text("Capacity: \(capacity.formatted()) seats")
                                .font(.montserratHeadline)
                                .foregroundColor(.fanPrimaryBlue)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
                    
                    Text("Stadium details coming soon")
                        .font(.montserratBody)
                        .foregroundColor(.fanGrayText)
                }
                .padding()
            }
        }
        .navigationTitle(stadium.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadStadium()
        }
    }
}

#Preview {
    NavigationStack {
        StadiumDetailView(stadium: Stadium(
            id: "1",
            name: "Emirates Stadium",
            city: "London",
            country: "England",
            capacity: 60704
        ))
    }
}
