# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HabitBuddy is a native iOS habit tracking app built with SwiftUI + SwiftData. Single app target, no package manifest, no test target. Swift 6 (`.swift-version`, `SWIFT_VERSION = 6.0`), iOS deployment target 18.6.

## Build and Development Commands

```bash
# Build (what CI runs)
xcodebuild -project HabitBuddy.xcodeproj -scheme HabitBuddy -configuration Debug \
  -destination 'generic/platform=iOS Simulator' clean build

# Build & run on a concrete simulator
xcodebuild -project HabitBuddy.xcodeproj -scheme HabitBuddy \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Lint (strict — any warning fails; warning_threshold is 1)
swiftlint --strict --config .swiftlint.yml

# Format check (never auto-fix in CI)
swiftformat --lint . --exclude Pods,DerivedData
```

There is no test target, so there are no test commands. If tests are added, they need a new target in `HabitBuddy.xcodeproj` and a CI step.

The `HabitBuddy` scheme is not shared (`xcshareddata/xcschemes` is absent); Xcode autocreates it. If scheme resolution ever fails in a fresh checkout, share the scheme rather than working around it.

`.github/workflows/main.yml` runs build → SwiftLint → SwiftFormat on pushes/PRs to `main`.

## Architecture

### Two parallel model layers

This is the single most important thing to understand before touching data code.

- **Persistence models** (`Services/Models/`): `StoredHabit` and `HabitCompletion` are SwiftData `@Model` classes. `StoredHabit` owns `completions` with a `.cascade` delete rule; `HabitCompletion` holds the inverse `habit` reference.
- **Display models** (`Modules/HabitList/Model/`, `*ViewState.swift`): `Habit`, `CardDisplayData`, `HabitListDisplayData` are plain value types built for rendering.

`StoredHabit.toHabit()` was written to bridge the two, but **the display layer is currently dead code**: views take `StoredHabit` directly, and `toHabit()`, `Habit`, `HabitList`, `MockStore` and the `CardDisplayData` array built in `HabitListViewModel` have no live readers. Treat `StoredHabit` as the real model and don't add to the display layer without reviving it deliberately.

Color crosses into persistence as a hex string: `StoredHabit.colorHex` ⇄ `Color(hex:)` / `Color.toHex()` in `Color+Extension.swift`. Never store a `Color` in a `@Model`.

### Persistence flow

`HabitBuddyApp.init()` builds the `ModelContainer` for the `[StoredHabit, HabitCompletion]` schema, injects it via `.modelContainer(_:)`, **and** calls `HabitStorageService.initialize(with: modelContainer.mainContext)`.

`HabitStorageService` is a `@MainActor` singleton (`.shared`) holding an optional `ModelContext`. Every method guards on that optional and fails soft (prints, returns empty/`false`). ViewModels and some views call `HabitStorageService.shared` directly rather than receiving an injected dependency — there is no DI container. Adding a `@Model` type means adding it to the `Schema` array in `HabitBuddyApp`.

Completions are keyed by `Calendar.current.startOfDay(for:)`; always normalize a date to start-of-day before comparing or writing completion records.

`Mock/MockStore.swift` is leftover sample `CardDisplayData` — it is no longer the data source. Don't wire new features to it.

### Day-of-week convention (currently inconsistent)

Two incompatible encodings of "which day" are in the codebase:

- `Date.dayOfWeek` (`Date+Extension.swift`) returns **Monday = 1 … Sunday = 7**. `HabitStorageService.loadHabits(for:)` filters `selectedDays.contains(dayIndex)` with it.
- `WeekdayPicker` (`Modules/Create/View/LabeledPicker.swift`) writes **0 … 6**, as an index into `Calendar.current` weekday symbols rotated to start at `firstWeekday`.

These do not line up, so saved habits surface on the wrong day. Pick one convention before adding any day-based feature.

`Date+Extension` also provides `currentWeek` / `nextWeek` / `previousWeek` for the week strip, and retroactively conforms `Date` to `Identifiable`.

### Observation

ViewModels are `@MainActor @Observable final class` (Swift Observation), held by views as `@State var viewModel = ...`. `WeekViewModel` is the one holdover still on `ObservableObject` + `@Published`; new ViewModels should use `@Observable`.

Each screen pairs a ViewModel with a `ViewState` file. Two shapes are in use:
- `HabitListViewState` — a `.loading` / `.loaded(data)` / `.error(String)` enum, switched over in the view body (`.loading` renders the loaded layout with `.redacted(reason: .placeholder)`).
- `CreateHabitViewState` — a plain mutable struct of form fields with a `static var defaultState`.

Refresh is manual and pull-based: `HabitListView` calls `viewModel.loadData()` in `.onAppear` and in the `.sheet` dismiss handler, and `HabitListViewModel.selectedDate` refetches in `didSet`. Nothing observes SwiftData with `@Query`, so a write made elsewhere will not propagate on its own — trigger a reload.

### Module layout

`HabitBuddy/Modules/<Feature>/` holds `<Feature>View.swift`, `<Feature>ViewModel.swift`, `<Feature>ViewState.swift`, plus `View/`, `Model/`, `Submodules/`. Navigation is shallow: `HabitBuddyApp` → `ContentView` → `HabitListView`, with `CreateHabitView` presented as a `.sheet`.

### Styling tokens

Never hardcode colors, fonts, or spacing — everything routes through `Extensions/`:
- `Color.Font.*`, `Color.Background.*` (incl. `greenAccent` / `roseAccent` / `yellowAccent`), `Color.TextField.border`
- `Font.customHeader`, `.customTitle`, `.customSubtitle`, `.primaryCompressed` (Helvetica, Obviously-Semibold)
- `CGFloat.horizontalSpacing`, `.verticalSpacing`, `.doubleVerticalSpacing`, `.textFieldPadding`

Reusable SwiftUI styles live in `Style/` (`ButtonCustomStyle`, `CheckboxToggleStyle`, `Shimmer`).

## Conventions

- **SwiftLint** (`.swiftlint.yml`, scoped to `HabitBuddy/`): `trailing_comma` is disabled for Swift 6, as are `line_length`, `force_unwrapping`, `identifier_name`, `type_name`. Opt-in rules that bite most often: `sorted_imports`, `implicit_return`, `redundant_type_annotation`, `explicit_init`, `first_where` / `last_where`, `switch_case_on_newline`, `let_var_whitespace`. Analyzer rules `unused_import` and `unused_declaration` are on.
- Files start with the standard Xcode header comment (`//  Name.swift` / `//  HabitBuddy` / `//  Created by …`). Keep it on new files.
- Types are sectioned with `// MARK: - Properties`, `// MARK: - Lifecycle`, `// MARK: - Public`, `// MARK: - Private`.
- Some comments, `TODO`s, and a few user-facing strings are in Russian. There is no localization layer; strings are inline literals.
