Pod::Spec.new do |s|
  s.name        = "Swift-Prelude"
  s.version     = "0.1.2"
  s.summary     = "🎶 A collection of types and functions that enhance the Swift language."
  s.homepage    = "https://github.com/pointfreeco/swift-prelude"
  s.license     = { :type => "MIT" }
  s.authors     = { "mbrandonw" => "brandon@pointfree.co", "stephencelis" => "stephen@pointfree.co" }

  s.requires_arc = true
  s.swift_version = "4.1.1"
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/pointfreeco/swift-prelude.git", :tag => s.version }
  s.source_files = "Sources/*/*.swift"
end
