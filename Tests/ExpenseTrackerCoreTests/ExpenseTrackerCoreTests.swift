import Foundation
import Testing
@testable import ExpenseTrackerCore

@Suite("Expense tracker core")
struct ExpenseTrackerCoreTests {
    @Test("Filters by category, amount and search text")
    func filterFlow() async {
        let food = ExpenseCategory(name: "Food", icon: "fork.knife", colorHex: "#B57AFF")
        let transport = ExpenseCategory(name: "Transport", icon: "car.fill", colorHex: "#4ED8F5")

        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let store = ExpenseStore(expenses: [
            Expense(amount: 12, note: "Lunch", categoryID: food.id, date: date),
            Expense(amount: 40, note: "Taxi", categoryID: transport.id, date: date),
            Expense(amount: 9, note: "Snack", categoryID: food.id, date: date)
        ])

        let result = await store.filtered(
            ExpenseFilter(
                categoryIDs: [food.id],
                amountRange: 10...20,
                query: "lunch"
            )
        )

        #expect(result.count == 1)
        #expect(result.first?.note == "Lunch")
    }

    @Test("Builds 6-month monthly totals")
    func monthlyTotals() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let now = Date(timeIntervalSince1970: 1_736_899_200) // Jan 2025
        let category = UUID()
        let expenses = [
            Expense(amount: 100, categoryID: category, date: now),
            Expense(amount: 50, categoryID: category, date: calendar.date(byAdding: .month, value: -1, to: now)!),
            Expense(amount: 25, categoryID: category, date: calendar.date(byAdding: .month, value: -5, to: now)!)
        ]

        let totals = StatsEngine.monthlyTotals(expenses: expenses, monthsBack: 6, now: now, calendar: calendar)

        #expect(totals.count == 6)
        #expect(totals.last?.total == 100)
        #expect(totals.first?.total == 25)
    }

    @Test("Exports and imports CSV")
    func csvRoundTrip() {
        let categoryID = UUID()
        let expense = Expense(
            id: UUID(),
            amount: 19.99,
            note: "Coffee beans",
            categoryID: categoryID,
            date: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let csv = CSVService.export(expenses: [expense])
        let restored = CSVService.import(csv)

        #expect(restored.count == 1)
        #expect(restored[0].amount == 19.99)
        #expect(restored[0].note == "Coffee beans")
        #expect(restored[0].categoryID == categoryID)
    }
}
