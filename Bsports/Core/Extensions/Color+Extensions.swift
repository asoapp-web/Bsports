import SwiftUI

extension Color {
    // Primary Colors - Red/Black/White theme
    static var fanPrimaryBlue: Color { Color("PrimaryBlue") }  // #E31E24 - Primary Red
    static var fanLightBlue: Color { Color("LightBlue") }      // #FF4A58 - Light Red/Pink
    static var fanAccentYellow: Color { Color("AccentYellow") } // White accent
    
    // Background Colors (Dark theme)
    static var fanBackground: Color { Color("BackgroundDark") }  // #0D0D0D - Near black
    static var fanBackgroundCard: Color { Color("BackgroundCard") }  // #1C1C1C - Dark gray
    static var fanBackgroundDark: Color { Color("BackgroundDark") }
    
    // Text Colors
    static var fanTextPrimary: Color { Color("TextPrimary") }  // White text
    static var fanGrayText: Color { Color("GrayText") }        // Light gray text
    
    // Status Colors
    static var fanSuccess: Color { Color("Success") }
    static var fanWarning: Color { Color("Warning") }
    static var fanError: Color { Color("Error") }
}
