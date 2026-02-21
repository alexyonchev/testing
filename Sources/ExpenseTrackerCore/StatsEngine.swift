import Foundation

public struct MonthlyTotal: Equatable, Sendable {
    public var year: Int
    public var month: Int
    public var total: Decimal

    public init(year: Int, month: Int, total: Decimal) {
        self.year = year
        self.month = month
        self.total = total
    }
}

public struct DayTotal: Equatable, Sendable {
    public var date: Date
    public var total: Decimal

    public init(date: Date, total: Decimal) {
        self.date = date
        self.total = total
    }
}

public enum StatsEngine {
    public static func monthlyTotals(
        expenses: [Expense],
        monthsBack: Int,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> [MonthlyTotal] {
        precondition(monthsBack > 0, "monthsBack must be greater than 0")

        let startMonth = calendar.date(byAdding: .month, value: -(monthsBack - 1), to: now) ?? now
        let startComponents = calendar.dateComponents([.year, .month], from: startMonth)

        var buckets: [DateComponents: Decimal] = [:]
        for expense in expenses {
            let components = calendar.dateComponents([.year, .month], from: expense.date)
            buckets[components, default: 0] += expense.amount
        }

        return (0..<monthsBack).compactMap { offset in
            guard
                let date = calendar.date(byAdding: .month, value: offset, to: calendar.date(from: startComponents) ?? now)
            else {
                return nil
            }
            let components = calendar.dateComponents([.year, .month], from: date)
            return MonthlyTotal(
                year: components.year ?? 0,
                month: components.month ?? 0,
                total: buckets[components, default: 0]
            )
        }
    }

    public static func categoryBreakdown(expenses: [Expense]) -> [CategoryTotal] {
        let total = expenses.reduce(Decimal.zero) { $0 + $1.amount }
        guard total > 0 else { return [] }

        let grouped = Dictionary(grouping: expenses, by: { $0.categoryID })
        return grouped
            .map { categoryID, values in
                let subtotal = values.reduce(Decimal.zero) { $0 + $1.amount }
                return CategoryTotal(
                    categoryID: categoryID,
                    total: subtotal,
                    percentage: subtotal / total
                )
            }
            .sorted { $0.total > $1.total }
    }

    public static func dailyHistogram(
        expenses: [Expense],
        inMonthContaining date: Date,
        calendar: Calendar = .current
    ) -> [DayTotal] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: date),
            let dayRange = calendar.range(of: .day, in: .month, for: date)
        else {
            return []
        }

        let filtered = expenses.filter { monthInterval.contains($0.date) }

        return dayRange.compactMap { day in
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            guard let dayDate = calendar.date(from: components) else {
                return nil
            }
            let dayTotal = filtered
                .filter { calendar.isDate($0.date, inSameDayAs: dayDate) }
                .reduce(Decimal.zero) { $0 + $1.amount }
            return DayTotal(date: dayDate, total: dayTotal)
        }
    }
}
