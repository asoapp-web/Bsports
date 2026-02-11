import SwiftUI

struct StadiumCardView: View {
    let stadium: Stadium
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 40))
                .foregroundColor(.fanGrayText)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stadium.name)
                    .font(.montserratHeadline)
                    .foregroundColor(.white)
                
                if let city = stadium.city, let country = stadium.country {
                    Text("\(city), \(country)")
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
                
                if let capacity = stadium.capacity {
                    Text("Capacity: \(capacity.formatted())")
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StadiumCardView(stadium: Stadium(
        id: "1",
        name: "Emirates Stadium",
        city: "London",
        country: "England",
        capacity: 60704
    ))
    .padding()
    .background(Color.fanBackgroundDark)
}
