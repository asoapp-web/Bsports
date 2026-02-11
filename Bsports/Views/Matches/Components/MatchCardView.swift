import SwiftUI

struct MatchCardView: View {
    let match: Match
    
    var body: some View {
        VStack(spacing: 12) {
            // League name and live indicator
            HStack {
                Text(match.leagueName)
                    .font(.montserratCaption)
                    .foregroundColor(.fanPrimaryBlue)
                
                Spacer()
                
                if match.status == .live || match.status == .inPlay {
                    HStack(spacing: 4) {
                        LottieView.livePulse()
                            .frame(width: 16, height: 16)
                        Text("LIVE")
                            .font(.montserrat(.bold, size: 11))
                            .foregroundColor(.fanPrimaryBlue)
                    }
                } else {
                    Text(BsportsDateFormatter.shared.formatTime(match.date))
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            HStack(spacing: 16) {
                // Home Team
                VStack(spacing: 6) {
                    AsyncImage(url: URL(string: match.homeTeamLogoURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(systemName: "sportscourt.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.fanPrimaryBlue)
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Text(match.homeTeamName)
                        .font(.montserrat(.medium, size: 13))
                        .foregroundColor(.fanTextPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: 90)
                }
                .frame(maxWidth: .infinity)
                
                // Score or VS
                VStack(spacing: 4) {
                    if let homeScore = match.homeScore, let awayScore = match.awayScore {
                        Text("\(homeScore) - \(awayScore)")
                            .font(.montserrat(.bold, size: 24))
                            .foregroundColor(.fanTextPrimary)
                    } else {
                        Text("VS")
                            .font(.montserrat(.semibold, size: 16))
                            .foregroundColor(.fanGrayText)
                    }
                    
                    StatusBadge(status: match.status)
                }
                .frame(width: 80)
                
                // Away Team
                VStack(spacing: 6) {
                    AsyncImage(url: URL(string: match.awayTeamLogoURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(systemName: "sportscourt.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.fanPrimaryBlue)
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Text(match.awayTeamName)
                        .font(.montserrat(.medium, size: 13))
                        .foregroundColor(.fanTextPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: 90)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .fanPrimaryBlue.opacity(0.2), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct StatusBadge: View {
    let status: MatchStatus
    
    var body: some View {
        Text(status.displayName)
            .font(.montserrat(.medium, size: 10))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .cornerRadius(6)
    }
    
    private var statusColor: Color {
        switch status {
        case .live, .inPlay:
            return .fanPrimaryBlue
        case .finished:
            return .fanSuccess
        case .scheduled:
            return .fanPrimaryBlue
        case .postponed, .cancelled:
            return .fanWarning
        case .paused:
            return .orange
        }
    }
}

#Preview {
    VStack {
        MatchCardView(match: Match(
            id: "1",
            leagueId: "2021",
            leagueName: "Premier League",
            season: 2024,
            homeTeamId: "57",
            awayTeamId: "65",
            homeTeamName: "Arsenal",
            awayTeamName: "Manchester City",
            date: Date(),
            status: .live,
            homeScore: 2,
            awayScore: 1
        ))
        
        MatchCardView(match: Match(
            id: "2",
            leagueId: "2021",
            leagueName: "Premier League",
            season: 2024,
            homeTeamId: "57",
            awayTeamId: "65",
            homeTeamName: "Chelsea",
            awayTeamName: "Liverpool",
            date: Date(),
            status: .scheduled
        ))
    }
    .padding()
    .background(Color.fanBackground)
}
