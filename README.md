# ExpenseTrackerCore (iOS 26+ starter plan)

This repository contains a **foundation module** for an offline-first personal expense tracker plus a practical path for running it on a real iPhone.

## Product vision

A fast, dark-themed, offline iOS app for tracking daily spending:

- No account system
- No cloud sync
- Data remains on-device
- Optional nightly backups to any user-selected folder

## App structure (4-tab navigation)

1. **Home**
   - 6-month spending bar chart
   - Today's expenses list
   - Floating action button for quick add

2. **Expenses**
   - Full searchable history
   - Filters: category, date range, amount range
   - Swipe-to-delete + undo

3. **Stats**
   - Donut chart with drill-down by category
   - Daily/monthly histogram views
   - Category breakdown list with percentages

4. **Settings**
   - CSV import/export
   - Automated nightly backup
   - Category management
   - Home screen widget configuration

## Included in this repo

The Swift package `ExpenseTrackerCore` includes:

- `Expense`, `ExpenseCategory`, and filtering models
- Actor-based in-memory `ExpenseStore` with add/delete/undo/filter operations
- `StatsEngine` for:
  - monthly totals (for Home chart)
  - category breakdown (for donut + breakdown list)
  - daily histogram values
- `CSVService` for import/export workflows
- Unit tests for filtering, stats, and CSV roundtripping

---

## How to run this on your iPhone (step-by-step)

> This repo is a **Swift package**, not a full iOS app target yet. To test on-device, create a tiny SwiftUI app in Xcode and attach this package.

### 1) Open and test the package locally first

From repo root:

```bash
swift test
```

### 2) Create an iOS app shell in Xcode

1. Open Xcode → **File > New > Project > App (iOS)**.
2. Name it (for example, `ExpenseTrackerApp`).
3. Interface: **SwiftUI**, Language: **Swift**, Testing: optional.
4. In project settings, set deployment target to **iOS 26.0+** (or the latest available in your Xcode if iOS 26 SDK is not installed yet).

### 3) Add this package to the app

1. In Xcode, open your app project.
2. Go to **Package Dependencies**.
3. Click **+** and select this local folder (`/workspace/testing`) or your cloned repo path.
4. Add product: **ExpenseTrackerCore** to your app target.

### 4) Use the package in your app code

In your SwiftUI app target:

```swift
import SwiftUI
import ExpenseTrackerCore
```

Then instantiate `ExpenseStore`, seed sample categories/expenses, and render Home/Expenses/Stats tabs using package data.

### 5) Connect your iPhone and sign the app

1. Connect iPhone via USB (or wireless debugging).
2. On iPhone: trust the Mac if prompted.
3. In Xcode target settings:
   - **Signing & Capabilities**
   - Select your Team
   - Ensure Bundle ID is unique.
4. Select your iPhone as the run destination.
5. Press **Run**.

If install fails with “Developer Mode required”:

- iPhone **Settings > Privacy & Security > Developer Mode** → enable, restart phone.

### 6) Validate on-device behavior

For this package-level MVP, verify:

- add/delete/undo behavior through your UI wrapper using `ExpenseStore`
- filtering by category/date/amount/query
- chart data generation from `StatsEngine`
- CSV export/import roundtrip using Files app documents directory

### 7) Test nightly backup and widget (when app target is added)

These are app-target features (not package-only):

- Nightly backup: use `BGTaskScheduler` + user-chosen folder bookmark access
- Widget: add a WidgetKit extension, read shared data via App Group container

---

## Suggested next implementation steps (Xcode app target)

1. Add a SwiftUI iOS app target (`ExpenseTrackerApp`) and import `ExpenseTrackerCore`.
2. Build tab UI with `TabView` + dark design tokens.
3. Integrate `Charts` framework for bar and donut charts.
4. Replace in-memory store with SwiftData persistence.
5. Add `.fileImporter` / `.fileExporter` for CSV and backup folder picker.
6. Add `BGTaskScheduler` nightly backup task.
7. Add WidgetKit extension for spending summary widget.
