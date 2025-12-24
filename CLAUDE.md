# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HabitBuddy is a native iOS habit tracking app built with SwiftUI. The app uses MVVM architecture with SwiftUI's `@Published` properties for state management. Currently uses mock data (`MockStore`) - real data persistence is planned.

## Build and Development Commands

### Build
```bash
xcodebuild -project HabitBuddy.xcodeproj -scheme HabitBuddy -configuration Debug -destination 'generic/platform=iOS Simulator' clean build
```

### Linting
```bash
# Run SwiftLint (strict mode, treats warnings as errors)
swiftlint --strict --config .swiftlint.yml

# Run SwiftFormat in lint mode (check only, no changes)
swiftformat --lint . --exclude Pods,DerivedData
```

### CI Pipeline
The project uses GitHub Actions (`.github/workflows/main.yml`) which runs on pushes/PRs to `main`:
- Builds the project
- Runs SwiftLint in strict mode
- Runs SwiftFormat in lint mode

## Architecture

### Module Structure
The codebase follows a module-based architecture under `HabitBuddy/Modules/`:

**HabitList Module** (`Modules/HabitList/`)
- Main screen showing user's habits with week view
- ViewModels use `@MainActor` and `@Published` state properties
- State pattern: `.loading`, `.loaded(data)`, `.error`
- Contains submodule `Week/` for week calendar functionality
- View hierarchy: `HabitListView` → `WeekStackView` + `HabitScrollView` → `CardView` / `ColumnView`

**Create Module** (`Modules/Create/`)
- Sheet presentation for creating new habits
- Uses `@FocusState` for field management
- Reusable components: `LabeledInputField`, `LabeledPicker`

### Key Patterns

**State Management**
- ViewModels are `@MainActor final class` and inherit from `ObservableObject`
- Each view has corresponding `ViewState` enum (e.g., `HabitListViewState`, `CreateHabitViewState`)
- State changes trigger view updates via `@Published` properties

**Styling System**
- Centralized design tokens in `Extensions/`:
  - `Color+Extension.swift`: `Color.Font.*`, `Color.Background.*` (includes accent colors)
  - `Font+Extension.swift`: Custom fonts (Helvetica, Obviously-Semibold)
  - `CGFloat+Extension.swift`: Standard spacing values (`.horizontalSpacing`, `.verticalSpacing`, etc.)
- Custom SwiftUI styles in `Style/` (button, checkbox, shimmer effects)

**Data Layer**
- Currently uses `MockStore.swift` for placeholder data
- Models are in `Model/` subdirectories within each module
- ViewModels contain placeholder comments for future real data integration

### Navigation
- Root: `HabitBuddyApp` → `ContentView` → `HabitListView`
- CreateHabitView presented as `.sheet()`

## SwiftLint Configuration

The project has a custom `.swiftlint.yml` with many disabled rules and opt-in rules:
- **trailing_comma rule is disabled** (Swift 6 compatibility)
- force_cast, force_unwrapping, identifier_name are disabled
- Opt-in rules include: implicit_return, sorted_imports, weak_delegate, shorthand_optional_binding
- Analyzer rules: unused_import, unused_declaration

When writing code, follow the existing patterns seen in SwiftLint opt-in rules (e.g., use sorted imports, implicit returns where appropriate).

## Swift Version

Target Swift version is specified in `.swift-version` file at project root.
