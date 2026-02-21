import Foundation

public enum CSVService {
    public static func export(expenses: [Expense]) -> String {
        let header = "id,date,amount,category_id,note"
        let rows = expenses.map { expense in
            let note = (expense.note ?? "").replacingOccurrences(of: "\"", with: "\"\"")
            return "\(expense.id.uuidString),\(ISO8601DateFormatter().string(from: expense.date)),\(expense.amount),\(expense.categoryID.uuidString),\"\(note)\""
        }

        return ([header] + rows).joined(separator: "\n")
    }

    public static func `import`(_ csv: String) -> [Expense] {
        let lines = csv.split(whereSeparator: \ .isNewline)
        guard lines.count > 1 else { return [] }

        let formatter = ISO8601DateFormatter()
        return lines.dropFirst().compactMap { line in
            let parts = parseCSVLine(String(line))
            guard parts.count >= 5,
                  let id = UUID(uuidString: parts[0]),
                  let date = formatter.date(from: parts[1]),
                  let amount = Decimal(string: parts[2]),
                  let categoryID = UUID(uuidString: parts[3])
            else {
                return nil
            }

            let note = parts[4].isEmpty ? nil : parts[4]
            return Expense(id: id, amount: amount, note: note, categoryID: categoryID, date: date)
        }
    }

    private static func parseCSVLine(_ line: String) -> [String] {
        var values: [String] = []
        var current = ""
        var inQuotes = false
        var iterator = line.makeIterator()

        while let char = iterator.next() {
            if char == "\"" {
                if inQuotes {
                    if let next = iterator.next() {
                        if next == "\"" {
                            current.append("\"")
                        } else if next == "," {
                            values.append(current)
                            current = ""
                            inQuotes = false
                        } else {
                            inQuotes = false
                            current.append(next)
                        }
                    } else {
                        inQuotes = false
                    }
                } else {
                    inQuotes = true
                }
            } else if char == "," && !inQuotes {
                values.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }

        values.append(current)
        return values
    }
}
