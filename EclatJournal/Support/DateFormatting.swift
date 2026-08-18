import Foundation

extension Date {
    var eclatDayTitle: String {
        formatted(.dateTime.weekday(.wide).day().month(.wide))
    }

    var eclatShortTime: String {
        formatted(date: .omitted, time: .shortened)
    }
}
