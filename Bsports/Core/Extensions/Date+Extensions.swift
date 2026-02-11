import Foundation

extension Date {
    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func isTomorrow() -> Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    func isPast() -> Bool {
        self < Date()
    }
    
    func isFuture() -> Bool {
        self > Date()
    }
}
