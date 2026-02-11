import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    
    init(
        name: String,
        loopMode: LottieLoopMode = .loop,
        animationSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        
        // Load animation from bundle - try multiple methods
        var animation: LottieAnimation?
        
        // Method 1: Direct path lookup
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            animation = LottieAnimation.filepath(path)
        }
        
        // Method 2: Named lookup (without extension)
        if animation == nil {
            animation = LottieAnimation.named(name)
        }
        
        // Method 3: Try with Resources/Animations path
        if animation == nil, let resourcesPath = Bundle.main.resourcePath {
            let fullPath = "\(resourcesPath)/Animations/\(name).json"
            if FileManager.default.fileExists(atPath: fullPath) {
                animation = LottieAnimation.filepath(fullPath)
            }
        }
        
        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        
        if animation != nil {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update if needed
    }
}

// Convenience extensions for specific animation types
extension LottieView {
    static func loading() -> LottieView {
        LottieView(name: "Loading Logo Animation", loopMode: .loop)
    }
    
    static func success() -> LottieView {
        LottieView(name: "Success", loopMode: .playOnce, animationSpeed: 1.5)
    }
    
    static func livePulse() -> LottieView {
        LottieView(name: "Red Pulsing Dot", loopMode: .loop, animationSpeed: 1.0)
    }
    
    static func emptyMatches() -> LottieView {
        LottieView(name: "not found", loopMode: .loop, animationSpeed: 0.8)
    }
    
    static func emptyStatistics() -> LottieView {
        LottieView(name: "Data visualization #2", loopMode: .loop, animationSpeed: 0.8)
    }
    
    static func emptyFavorites() -> LottieView {
        LottieView(name: "Football team players", loopMode: .loop, animationSpeed: 0.8)
    }
}
