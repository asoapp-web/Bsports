import SwiftUI

struct StandingsView: View {
    let leagueId: String
    let season: Int?
    @StateObject private var viewModel: LeagueDetailViewModel
    
    init(leagueId: String, season: Int?) {
        self.leagueId = leagueId
        self.season = season
        _viewModel = StateObject(wrappedValue: LeagueDetailViewModel(leagueId: leagueId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    LottieView.loading()
                        .frame(width: 80, height: 80)
                    Text("Loading standings...")
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else if viewModel.standings.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "tablecells")
                        .font(.system(size: 50))
                        .foregroundColor(.fanGrayText)
                    Text("No standings available")
                        .font(.montserratHeadline)
                        .foregroundColor(.fanTextPrimary)
                    Text("Standings data is not available for this league")
                        .font(.montserratBody)
                        .foregroundColor(.fanGrayText)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        HStack(spacing: 0) {
                            Text("#")
                                .font(.montserrat(.bold, size: 12))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 32)
                            
                            Text("Team")
                                .font(.montserrat(.bold, size: 12))
                                .foregroundColor(.fanGrayText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("P")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 28)
                            
                            Text("W")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 28)
                            
                            Text("D")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 28)
                            
                            Text("L")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 28)
                            
                            Text("GD")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 32)
                            
                            Text("Pts")
                                .font(.montserrat(.bold, size: 11))
                                .foregroundColor(.fanGrayText)
                                .frame(width: 36)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.fanPrimaryBlue.opacity(0.1))
                        
                        // Rows
                        ForEach(viewModel.standings) { entry in
                            StandingsRowView(entry: entry)
                                .background(entry.rank % 2 == 0 ? Color.fanBackgroundCard : Color.fanBackground)
                        }
                    }
                    .background(Color.fanBackgroundCard)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                    .padding()
                }
            }
        }
        .background(Color.fanBackground)
        .task {
            await viewModel.loadStandings()
        }
    }
}

struct StandingsRowView: View {
    let entry: StandingsEntry
    
    var body: some View {
        HStack(spacing: 0) {
            // Position with color indicator
            ZStack {
                if entry.rank <= 4 {
                    Circle()
                        .fill(positionColor)
                        .frame(width: 24, height: 24)
                }
                Text("\(entry.rank)")
                    .font(.montserrat(.semibold, size: 13))
                    .foregroundColor(entry.rank <= 4 ? .fanTextPrimary : .fanTextPrimary)
            }
            .frame(width: 32)
            
            // Team
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: entry.teamLogoURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.fanGrayText)
                }
                .frame(width: 24, height: 24)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                Text(entry.teamName)
                    .font(.montserrat(.medium, size: 14))
                    .foregroundColor(.fanTextPrimary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(entry.played)")
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(.fanTextPrimary)
                .frame(width: 28)
            
            Text("\(entry.won)")
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(.fanSuccess)
                .frame(width: 28)
            
            Text("\(entry.draw)")
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(.fanGrayText)
                .frame(width: 28)
            
            Text("\(entry.lost)")
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(.fanError)
                .frame(width: 28)
            
            Text("\(entry.goalDifference > 0 ? "+" : "")\(entry.goalDifference)")
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(entry.goalDifference > 0 ? .fanSuccess : (entry.goalDifference < 0 ? .fanError : .fanGrayText))
                .frame(width: 32)
            
            Text("\(entry.points)")
                .font(.montserrat(.bold, size: 14))
                .foregroundColor(.fanPrimaryBlue)
                .frame(width: 36)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
    
    private var positionColor: Color {
        switch entry.rank {
        case 1...4:
            return .fanSuccess
        case 5...6:
            return .fanPrimaryBlue
        case 17...20:
            return .fanError
        default:
            return .clear
        }
    }
}

#Preview {
    StandingsView(leagueId: "2021", season: 2024)
}
