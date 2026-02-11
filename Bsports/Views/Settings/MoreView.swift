import SwiftUI

struct MoreView: View {
    @State private var showStatistics = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    NavigationLink(destination: FavoritesView()) {
                        MoreRowView(
                            icon: "heart.fill",
                            title: "Favorites",
                            iconColor: .fanPrimaryBlue
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: StatisticsView()) {
                        MoreRowView(
                            icon: "chart.bar.fill",
                            title: "Stats",
                            iconColor: .fanPrimaryBlue
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: SettingsView()) {
                        MoreRowView(
                            icon: "gearshape.fill",
                            title: "Settings",
                            iconColor: .fanPrimaryBlue
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("More")
    }
}

struct MoreRowView: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            Text(title)
                .font(.montserrat(.semibold, size: 16))
                .foregroundColor(.fanTextPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.fanTextPrimary)
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
        .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        MoreView()
    }
}
