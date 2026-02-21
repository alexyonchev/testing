import Foundation

public struct ExpenseCategory: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var icon: String
    public var colorHex: String

    public init(id: UUID = UUID(), name: String, icon: String, colorHex: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
    }
}

public struct Expense: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var amount: Decimal
    public var note: String?
    public var categoryID: UUID
    public var date: Date
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        amount: Decimal,
        note: String? = nil,
        categoryID: UUID,
        date: Date,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.note = note
        self.categoryID = categoryID
        self.date = date
        self.createdAt = createdAt
    }
}

public struct ExpenseFilter: Sendable {
    public var categoryIDs: Set<UUID>
    public var dateRange: ClosedRange<Date>?
    public var amountRange: ClosedRange<Decimal>?
    public var query: String?

    public init(
        categoryIDs: Set<UUID> = [],
        dateRange: ClosedRange<Date>? = nil,
        amountRange: ClosedRange<Decimal>? = nil,
        query: String? = nil
    ) {
        self.categoryIDs = categoryIDs
        self.dateRange = dateRange
        self.amountRange = amountRange
        self.query = query
    }
}

public struct CategoryTotal: Identifiable, Equatable, Sendable {
    public var id: UUID { categoryID }
    public var categoryID: UUID
    public var total: Decimal
    public var percentage: Decimal

    public init(categoryID: UUID, total: Decimal, percentage: Decimal) {
        self.categoryID = categoryID
        self.total = total
        self.percentage = percentage
    }
}
