# Contributing to flutter_motion_sensors

Thank you for your interest in contributing to flutter_motion_sensors!

## Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification, which aligns with our CHANGELOG format.

### Commit Message Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature (maps to "Added" in CHANGELOG)
- **fix**: A bug fix (maps to "Fixed" in CHANGELOG)
- **docs**: Documentation only changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring without changing functionality
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **build**: Changes to build system or dependencies
- **ci**: Changes to CI configuration
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scopes

- **android**: Android-specific changes
- **ios**: iOS-specific changes
- **web**: Web-specific changes
- **macos**: macOS-specific changes
- **windows**: Windows-specific changes
- **linux**: Linux-specific changes
- **example**: Example app changes
- **docs**: Documentation changes
- **deps**: Dependency updates
- **ci**: CI/CD changes
- **changelog**: CHANGELOG updates

### Examples

```bash
# New feature
feat(android): add sensor listener error handling

# Bug fix
fix(ios): resolve Swift compilation errors

# Documentation
docs: update README with example GIF

# Breaking change
feat!: change namespace to com.github.dhia_bechattaoui

BREAKING CHANGE: Android package namespace updated
```

### CHANGELOG Mapping

- `feat` → **Added** section
- `fix` → **Fixed** section
- `refactor`, `perf`, `style` → **Changed** section
- `docs` → **Changed** section (documentation)
- `chore`, `build`, `ci` → Usually not included unless significant

### Breaking Changes

Use `!` after the type to indicate a breaking change:
```
feat!: update minimum Flutter version to 3.32.0
```

This will be documented in the **Changed** section with a "BREAKING CHANGE" note.

