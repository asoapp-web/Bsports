import Foundation

struct BsportsDateFormatter {
    static let shared = BsportsDateFormatter()
    
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private let fullDateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "en_US")
        
        fullDateFormatter = DateFormatter()
        fullDateFormatter.dateStyle = .medium
        fullDateFormatter.timeStyle = .short
        fullDateFormatter.locale = Locale(identifier: "en_US")
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    func formatTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    func formatFullDate(_ date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
    
    func formatRelativeDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .day) {
            return formatDate(date)
        } else {
            return dateFormatter.string(from: date)
        }
    }
}
