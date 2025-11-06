# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-11-05

### Added
- Comprehensive example app with multiple demos showcasing all features
- Error handling for stream cancellation to prevent exceptions when switching tabs
- Improved status messages in Custom Sensor Types demo
- Enhanced logging in Android native implementation
- Added funding information in pubspec.yaml
- Added package topics for better discoverability

### Changed
- Updated SDK requirement to >=3.8.0
- Updated Flutter requirement to >=3.32.0
- Improved stream lifecycle management in Android and iOS implementations
- Enhanced error suppression for EventChannel cancellation errors
- Updated Android namespace to com.github.dhia_bechattaoui

### Fixed
- Fixed stream cancellation errors when switching between tabs in TabBarView
- Fixed button state updates in Stream Demo page
- Fixed Swift compilation errors in iOS plugin
- Fixed missing flutter_web_plugins dependency
- Fixed formatting issues to achieve 160/160 pana score
- Fixed missing documentation for constructors
- Fixed Android sensor listener registration logging
- Fixed dependency version constraints in example app to match main package version (0.1.0)
- Updated example app dependencies (cupertino_icons, flutter_lints) to compatible versions
- Aligned example app Flutter version requirement with main package (>=3.32.0)

## [0.0.2] - 2025-08-30

### Added
- **Full Swift Package Manager (SPM) support** for iOS and macOS
- **Native CoreMotion integration** for optimal performance and battery efficiency
- **Real-time motion data streaming** at 60Hz update rate
- **Automatic motion sensor permission handling** with proper Info.plist configurations
- **Swift 5.0+ compatibility** with modern iOS/macOS versions
- **Comprehensive SPM documentation** and usage examples
- **Enhanced platform support documentation** with SPM integration details

### Changed
- **Improved platform support** with native iOS/macOS implementations
- **Enhanced error handling** and fallback mechanisms for better reliability
- **Updated documentation** to reflect SPM capabilities and usage

### Fixed
- **Resolved SPM compatibility warnings** that were affecting package scoring
- **Improved test coverage** and reliability across all platforms
- **Enhanced platform interface** for better cross-platform compatibility

### Security
- **Added proper permission handling** for motion sensor access on iOS/macOS

## [0.0.1] - 2024-12-19

### Added
- Initial release of flutter_motion_sensors package
- Basic motion sensor integration using sensors_plus
- Cross-platform support for all major Flutter platforms
- Plugin architecture for native platform implementations
- Comprehensive test coverage
- Documentation and examples

---

## Version History

- **0.0.2** - Major update with full Swift Package Manager support, native CoreMotion integration, and enhanced platform support
- **0.0.1** - Initial release with basic motion sensor functionality and cross-platform support

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
