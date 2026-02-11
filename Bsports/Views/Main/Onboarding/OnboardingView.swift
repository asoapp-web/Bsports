import SwiftUI
import Lottie

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage(BsportsUserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            // Dark background with red gradient accents
            LinearGradient(
                colors: [Color.fanBackground, Color.fanBackground, Color.fanPrimaryBlue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)
                    
                    FeaturesPage()
                        .tag(1)
                    
                    ReadyPage()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .disabled(true) // Disable swipe gestures
                
                // Bottom section with indicators and button
                VStack(spacing: 20) {
                    // Custom page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color.fanPrimaryBlue : Color.fanGrayText.opacity(0.3))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.2), value: currentPage)
                        }
                    }
                    
                    // Next/Get Started button
                    if currentPage < 2 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                    .font(.montserrat(.bold, size: 18))
                                    .foregroundColor(.fanTextPrimary)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.fanTextPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.fanPrimaryBlue)
                            .cornerRadius(16)
                            .shadow(color: .fanPrimaryBlue.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        // Get Started button on last page
                        Button(action: {
                            // Set flag and close
                            hasCompletedOnboarding = true
                            // Close the fullScreenCover
                            isPresented = false
                        }) {
                            Text("Get Started")
                                .font(.montserrat(.bold, size: 18))
                                .foregroundColor(.fanTextPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.fanPrimaryBlue)
                                .cornerRadius(16)
                                .shadow(color: .fanPrimaryBlue.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Logo
            Image("BsportsLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .shadow(color: .fanPrimaryBlue.opacity(0.4), radius: 25, x: 0, y: 10)
            
            // Lottie animation below logo
            LottieView(name: "Football team players", loopMode: .loop, animationSpeed: 0.8)
                .frame(width: 150, height: 150)
            
            VStack(spacing: 16) {
                Text("Bsports")
                    .font(.montserrat(.bold, size: 32))
                    .foregroundColor(.fanTextPrimary)
                
                Text("Your ultimate football companion")
                    .font(.montserratBody)
                    .foregroundColor(.fanGrayText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct FeaturesPage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Lottie animation
            LottieView(name: "Data visualization #2", loopMode: .loop, animationSpeed: 0.8)
                .frame(width: 180, height: 180)
            
            VStack(spacing: 16) {
                FeatureRow(icon: "calendar.badge.clock", title: "Live Scores", description: "Real-time match updates")
                FeatureRow(icon: "star.fill", title: "Favorites", description: "Follow your teams & leagues")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Statistics", description: "Track your watching history")
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with white background
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.fanPrimaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.montserrat(.semibold, size: 18))
                    .foregroundColor(.fanTextPrimary)
                
                Text(description)
                    .font(.montserratCaption)
                    .foregroundColor(.fanGrayText.opacity(0.8)) // Lighter gray for better visibility
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct ReadyPage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success animation
            LottieView(name: "Success", loopMode: .loop, animationSpeed: 0.6)
                .frame(width: 150, height: 150)
            
            VStack(spacing: 16) {
                Text("You're all set!")
                    .font(.montserrat(.bold, size: 28))
                    .foregroundColor(.fanTextPrimary)
                
                Text("Start exploring matches and\nbuild your fan profile")
                    .font(.montserratBody)
                    .foregroundColor(.fanGrayText.opacity(0.8)) // Lighter gray
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
