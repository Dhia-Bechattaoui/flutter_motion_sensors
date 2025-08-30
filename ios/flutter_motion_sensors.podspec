#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_motion_sensors.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_motion_sensors'
  s.version          = '0.0.2'
  s.summary          = 'Device motion and orientation-based animations for Flutter'
  s.description      = <<-DESC
Device motion and orientation-based animations for Flutter. Supports iOS, Android, Web, Windows, macOS, and Linux with WASM compatibility.
                       DESC
  s.homepage         = 'https://github.com/Dhia-Bechattaoui/flutter_motion_sensors'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
