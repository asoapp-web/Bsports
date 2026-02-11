import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let onAction: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.onAction = onAction
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color("GrayText"))
            
            Text(title)
                .font(.montserratHeadline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.montserratBody)
                .foregroundColor(Color("GrayText"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let actionTitle = actionTitle, let onAction = onAction {
                Button(action: onAction) {
                    Text(actionTitle)
                        .font(.montserrat(.medium, size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.fanPrimaryBlue)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "calendar",
        title: "No matches found",
        message: "Try adjusting your filters",
        actionTitle: "Refresh",
        onAction: {}
    )
    .padding()
    .background(Color("BackgroundDark"))
}
