import SwiftUI

extension Font {
    static func montserrat(_ weight: MontserratWeight = .regular, size: CGFloat) -> Font {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "Montserrat-Regular"
        case .medium:
            fontName = "Montserrat-Medium"
        case .semibold:
            fontName = "Montserrat-SemiBold"
        case .bold:
            fontName = "Montserrat-Bold"
        }
        return Font.custom(fontName, size: size)
    }
    
    enum MontserratWeight {
        case regular
        case medium
        case semibold
        case bold
    }
    
    // Convenience methods
    static var montserratTitle: Font {
        .montserrat(.bold, size: 24)
    }
    
    static var montserratHeadline: Font {
        .montserrat(.medium, size: 18)
    }
    
    static var montserratBody: Font {
        .montserrat(.regular, size: 16)
    }
    
    static var montserratCaption: Font {
        .montserrat(.regular, size: 13)
    }
    
    static var montserratScore: Font {
        .montserrat(.bold, size: 28)
    }
}
