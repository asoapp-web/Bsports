import SwiftUI

struct SearchBarTextColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Configure search bar text field appearance
                if #available(iOS 13.0, *) {
                    UISearchBar.appearance().searchTextField.textColor = .white
                    UISearchBar.appearance().searchTextField.backgroundColor = UIColor(Color.fanBackgroundCard)
                    UISearchBar.appearance().searchTextField.attributedPlaceholder = NSAttributedString(
                        string: "Search",
                        attributes: [.foregroundColor: UIColor.lightGray]
                    )
                    UISearchBar.appearance().searchTextField.leftView?.tintColor = UIColor.lightGray
                }
            }
    }
}

extension View {
    func searchBarTextColor() -> some View {
        modifier(SearchBarTextColorModifier())
    }
}
