### 🔄 Project Awareness & Context
- **Always read `PLANNING.md`** at the start of a new conversation to understand the project's architecture, goals, style, and constraints.
- **Check `TASK.md`** before starting a new task. If the task isn't listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** as described in `PLANNING.md`.

### 🧱 Code Structure & Modularity
- **Never create a file longer than 500 lines of code.** If a file approaches this limit, refactor by splitting it into modules or helper files.
- **Organize code into clearly separated modules**, grouped by feature or responsibility.
- **Use clear, consistent imports** (prefer relative imports within packages, use `package:` imports for cross-package references).

### 🧪 Testing & Reliability
- **Always create Flutter widget tests and unit tests for new features** (widgets, services, models, etc).
- **After updating any logic**, check whether existing tests need to be updated. If so, do it.
- **Tests should live in a `/test` folder** mirroring the main `lib/` structure.
  - Include at least:
    - 1 test for expected use
    - 1 edge case
    - 1 failure case

### ✅ Task Completion
- **Mark completed tasks in `TASK.md`** immediately after finishing them.
- Add new sub-tasks or TODOs discovered during development to `TASK.md` under a "Discovered During Work" section.

### 📎 Style & Conventions
- **Use Dart/Flutter** as the primary language/framework.
- **Follow Effective Dart style guidelines** (https://dart.dev/effective-dart).
- **Use strong typing** – avoid `dynamic` where possible, leverage Dart's type system.
- **Use `const` constructors** wherever possible for widget performance.
- **Prefer immutable data models** – use `final` fields and factory constructors.
- **State management**: Use `StatefulWidget` with `setState` for simple local state; escalate to Provider/Riverpod only if complexity warrants it.
- Write **dartdoc comments for every public function and class** using the standard Dart style:
  ```dart
  /// Brief summary of the function.
  ///
  /// [param1] describes the first parameter.
  ///
  /// Returns a description of the return value.
  void example(String param1) {
    // ...
  }
  ```
- **Name files in snake_case**, classes in PascalCase, variables/functions in camelCase.
- **Organize widgets**: one primary widget per file, extract sub-widgets into separate files when they exceed ~100 lines.

### 📚 Documentation & Explainability
- **Update `README.md`** when new features are added, dependencies change, or setup steps are modified.
- **Comment non-obvious code** and ensure everything is understandable to a mid-level developer.
- When writing complex logic, **add an inline `// Reason:` comment** explaining the why, not just the what.

### 🧠 AI Behavior Rules
- **Never assume missing context. Ask questions if uncertain.**
- **Never hallucinate packages or APIs** – only use known, verified Dart/Flutter packages from pub.dev.
- **Always confirm file paths and module names** exist before referencing them in code or tests.
- **Never delete or overwrite existing code** unless explicitly instructed to or if part of a task from `TASK.md`.

### 📱 Flutter-Specific Rules
- **Target Android** as the primary platform for this project.
- **Use Material 3 (Material You)** design system for UI components.
- **Handle app lifecycle** properly – pause/resume timers when the app goes to background.
- **Test on real devices** when possible, use `flutter devices` to discover connected devices.
- **Keep `pubspec.yaml` clean** – remove unused dependencies, pin versions where appropriate.
- **Use `flutter analyze`** before committing to catch lint issues early.
