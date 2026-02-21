import Foundation

public actor ExpenseStore {
    private var expenses: [Expense]

    public init(expenses: [Expense] = []) {
        self.expenses = expenses
    }

    public func add(_ expense: Expense) {
        expenses.append(expense)
    }

    @discardableResult
    public func delete(id: UUID) -> Expense? {
        guard let index = expenses.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        return expenses.remove(at: index)
    }

    public func undoDelete(_ expense: Expense) {
        expenses.append(expense)
    }

    public func all() -> [Expense] {
        expenses.sorted { $0.date > $1.date }
    }

    public func today(now: Date = Date(), calendar: Calendar = .current) -> [Expense] {
        expenses
            .filter { calendar.isDate($0.date, inSameDayAs: now) }
            .sorted { $0.date > $1.date }
    }

    public func filtered(_ filter: ExpenseFilter) -> [Expense] {
        expenses
            .filter { expense in
                if !filter.categoryIDs.isEmpty, !filter.categoryIDs.contains(expense.categoryID) {
                    return false
                }

                if let dateRange = filter.dateRange, !dateRange.contains(expense.date) {
                    return false
                }

                if let amountRange = filter.amountRange, !amountRange.contains(expense.amount) {
                    return false
                }

                if let query = filter.query, !query.isEmpty {
                    let text = (expense.note ?? "").localizedLowercase
                    if !text.contains(query.localizedLowercase) {
                        return false
                    }
                }

                return true
            }
            .sorted { $0.date > $1.date }
    }
}
