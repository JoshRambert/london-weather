# AGENTS.md

Instructions for AI agents working in this project. In the ai-rules repo this template is `APPAGENTS.md`; copy it to the root of every iOS or Android app repo as `AGENTS.md` that follows the shared **ai-rules** standards ([JoshRambert/ai-rules](https://github.com/JoshRambert/ai-rules)).

## 1. Check for ai-rules first

Before adding code, scaffolding, refactoring, porting, or building out any feature, confirm the ai-rules repo is reachable. Do this at the start of every task that changes code, not only once per project.

Look for the repo in this order and use the first one that exists:

1. The path in the `AI_RULES_DIR` environment variable
2. `~/Desktop/ai-rules`
3. The target directory of the symlinks in `.cursor/rules/` (this project) or `~/.cursor/rules/` (global)

The repo counts as **found** only when the directory exists and contains all of these files:

- `architecture.mdc`
- `ios-navigation.mdc`
- `ios-storage.mdc`
- `ios-auth-validation.mdc`
- `ui-naming.mdc`
- `ios-to-android-port.mdc`
- `android-play-console.mdc`

Also check that any `.mdc` symlinks in `.cursor/rules/` or `~/.cursor/rules/` resolve, that the rules are installed in at least one of those two locations, and that any copied rule files are in sync with `ai-rules`. A broken symlink, missing rule, or stale copy means the latest rules are not loading, even if a copy of the repo exists somewhere else.

Quick check:

```bash
link_target="$(readlink .cursor/rules/architecture.mdc 2>/dev/null || readlink "$HOME/.cursor/rules/architecture.mdc" 2>/dev/null)"
dir="${AI_RULES_DIR:-}"
[ -z "$dir" ] && [ -d "$HOME/Desktop/ai-rules" ] && dir="$HOME/Desktop/ai-rules"
[ -z "$dir" ] && [ -n "$link_target" ] && dir="$(dirname "$link_target")"
dir="${dir:-$HOME/Desktop/ai-rules}"
for f in architecture.mdc ios-navigation.mdc ios-storage.mdc ios-auth-validation.mdc ui-naming.mdc ios-to-android-port.mdc android-play-console.mdc; do
  [ -f "$dir/$f" ] || echo "MISSING RULE IN AI-RULES: $dir/$f"
  installed=""
  [ -e ".cursor/rules/$f" ] && installed=".cursor/rules/$f"
  [ -z "$installed" ] && [ -e "$HOME/.cursor/rules/$f" ] && installed="$HOME/.cursor/rules/$f"
  if [ -z "$installed" ]; then
    echo "NOT INSTALLED IN CURSOR RULES: $f"
  elif [ -f "$dir/$f" ] && ! cmp -s "$installed" "$dir/$f"; then
    echo "OUT OF SYNC WITH AI-RULES: $installed"
  fi
done
find .cursor/rules "$HOME/.cursor/rules" -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null | sed 's/^/BROKEN SYMLINK: /'
```

No output means the check passed.

## 2. If ai-rules cannot be found, stop and alert the engineer

Do **not** write or change code, and do not fall back to your own conventions. Instead, tell the engineer right away, using a question/prompt tool if one is available (for example `AskQuestion` in Cursor). The alert must include:

- That the ai-rules repo (or its `.cursor/rules` symlinks) could not be verified, so the project's DMVVM-C (Dual-Write Models MVVM-C) architecture, navigation, storage, and auth standards are not being applied
- Exactly what was checked and what failed (missing directory, missing files, uninstalled or out-of-sync rules, or broken symlink paths)
- How to fix it:
  - Clone it: `git clone git@github.com:JoshRambert/ai-rules.git ~/Desktop/ai-rules`
  - Or point to an existing copy: `export AI_RULES_DIR=/path/to/ai-rules`
  - Then create/refresh the symlinks using the install steps in the ai-rules `README.md`, and open a new chat so the rules load

Offer these choices:

- **I've fixed it, check again** — re-run the check in step 1
- **Proceed without ai-rules for this task** — only continue if the engineer explicitly picks this, and say in your final summary that the work was done without the shared rules

## 3. Read the rules that apply to the task

Once ai-rules is found, read the relevant files before writing code, even if they already appear in your context, and follow them over any general habits:

| Task touches | Read |
|---|---|
| Any code change (iOS or Android) | `architecture.mdc`, `ui-naming.mdc` |
| Routes, screens, modals, sheets, `Store` / `AppCoordinator`, `RootView` / `RootScreen` | `ios-navigation.mdc` |
| SwiftData / Room, Firestore, `RemoteStore`, `UserDefaults` / `AppPreferences`, `*Codable` / `*Entity` dual-write models | `ios-storage.mdc` |
| Email / password sign-up or login, `AuthEmailPasswordValidation`, Firebase Auth error mapping | `ios-auth-validation.mdc` |
| Initiating or working on an iOS → Android port | `ios-to-android-port.mdc` (run **Phase 0** before writing code) |
| Android release / Play Console publishing | `android-play-console.mdc` |

## 4. Non-negotiable architectural & workflow guardrails (iOS & Android)

1. **DMVVM-C (Dual-Write Models MVVM-C — no Repository or UseCase layer):** Dual-Write Models means the domain `*Codable` owns its read/write helpers in the same file. On both iOS and Android, ViewModels receive `ModelContext` (iOS) or Room `@Dao`s + `AppPreferences` (Android) in `init`/`constructor` and call dual-write helpers (`toEntity()`, `saveToFirestore()`, `saveToFirestoreThrowing()`, `fetchFromFirestore()`, `syncMostRecentFromFirestoreTo*`, and rollback-safe copy-on-mutate helpers) **directly on the domain `*Codable` models** through the `RemoteStore.current` seam. Never introduce `*Repository` or `*UseCase` wrapper classes.
2. **Single Coordinator (`Store` on iOS, `AppCoordinator` on Android):** Views/Screens communicate exclusively through their ViewModel and never navigate or present app-level alerts/sheets directly. Global errors and confirmations always route through the Coordinator.
3. **New app from scratch — prompt for bottom sheets:** Before scaffolding `Store` / `RootView` (or `AppCoordinator` / `RootScreen`), ask the engineer whether the app should include the **opt-in bottom sheet architecture** (`BottomSheetRoute`, `PendingSheetActions`, `RootBottomSheetCoordinator`). Do not assume either way.
4. **Initiating an iOS → Android port — run Phase 0 first:** Before writing any Kotlin code, execute **Phase 0** of `ios-to-android-port.mdc`:
   - Ensure `AGENTS.md` (copied from `APPAGENTS.md`) and `.cursor/rules/` symlinks are installed in the Android repo.
   - Audit the iOS source repo (check whether iOS uses `BottomSheetRoute` or opted out so Android matches it; inventory all `*Entity` / `*Codable` dual-write models, `FirestoreConstants`, `UserDefaults` / `pendingSyncIds`, bundled JSON assets, services, and Cloud Functions).
   - Prompt the engineer once for any kickoff decisions not in the iOS code (`applicationId`, Android v1 Auth provider list, UI fidelity mode, and credential/product ID status).
5. **Per-phase parity gate on Android ports:** After every phase (Phases 1–6), re-open the iOS source files that phase ported, diff line-by-line (copy, keys, defaults, colors, spacing, rollback/error behavior), run mirrored unit tests, and write the parity log before starting the next phase.
6. **Service files over 300 lines:** A file in `Services/` (iOS) or `services/` (Android) that exceeds 300 lines must be divided into grouped-logic sections headed by `// MARK: - Title` (same comment syntax on both platforms). Do not leave a 300+ line service as an undifferentiated blob.

If a rule conflicts with what the engineer asked for, point out the conflict and ask before deviating.
