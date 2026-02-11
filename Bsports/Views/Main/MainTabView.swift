import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    init() {
        // Configure tab bar appearance - red background with black icons
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.fanPrimaryBlue) // Red background
        
        // Selected item - white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Unselected item - black
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configure navigation bar appearance - white text on black background
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color.fanBackground) // Black background
        
        // Large title text - white
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Montserrat-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        // Regular title text - white
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Montserrat-Semibold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        // Back button and other items - white
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Configure search bar text field - white text on dark background
        // This applies globally to all search bars in the app
        if #available(iOS 13.0, *) {
            // Set text color for search text field
            UISearchBar.appearance().searchTextField.textColor = .white
            
            // Set background color for search text field
            UISearchBar.appearance().searchTextField.backgroundColor = UIColor(Color.fanBackgroundCard)
            
            // Set placeholder color
            UISearchBar.appearance().searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [.foregroundColor: UIColor.lightGray]
            )
            
            // Set icon color
            UISearchBar.appearance().searchTextField.leftView?.tintColor = UIColor.lightGray
            
            // Also configure via UITextField appearance for broader compatibility
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
                .foregroundColor: UIColor.white
            ]
        }
        
        // Search bar background
        UISearchBar.appearance().barTintColor = UIColor(Color.fanBackground)
        UISearchBar.appearance().searchBarStyle = .minimal
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MatchesListView()
                .tabItem {
                    Label("Matches", systemImage: "calendar")
                }
                .tag(0)
            
            LeaguesListView()
                .tabItem {
                    Label("Leagues", systemImage: "trophy")
                }
                .tag(1)
            
            TeamsListView()
                .tabItem {
                    Label("Teams", systemImage: "person.3.fill")
                }
                .tag(2)
            
            StadiumsListView()
                .tabItem {
                    Label("Stadiums", systemImage: "building.2.fill")
                }
                .tag(3)
            
            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis")
            }
            .tag(4)
        }
        .tint(.white)
    }
}

#Preview {
    MainTabView()
}
