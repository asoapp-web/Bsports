import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @AppStorage(BsportsUserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Dark gradient background with red accent
            LinearGradient(
                colors: [Color.fanBackground, Color.fanPrimaryBlue.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App Logo
                Image("BsportsLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(color: .fanPrimaryBlue.opacity(0.3), radius: 20, x: 0, y: 10)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                Text("Bsports")
                    .font(.montserrat(.bold, size: 28))
                    .foregroundColor(.fanTextPrimary)
                    .opacity(logoOpacity)
                
                LottieView.loading()
                    .frame(width: 60, height: 60)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            // Animate logo
            withAnimation(.easeOut(duration: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Navigate after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView(isPresented: $isActive)
                }
            }
        }
        .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
            // When onboarding is completed, close the cover and reopen it to show MainTabView
            if newValue && !oldValue {
                isActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
