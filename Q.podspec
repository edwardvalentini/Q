#
# Be sure to run `pod lib lint Q.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Q"
  s.version          = "0.0.1"
  s.summary          = "Persistent Queue written in Swift with a core data backend."
  s.description      = <<-DESC
  Persistent Queue written in swift with a core data backend.
                       DESC

  s.homepage         = "https://github.com/edwardvalentini/Q"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Edward Valentini" => "edward@interlook.com" }
  s.source           = { :git => "https://github.com/edwardvalentini/Q.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/edwardvalentini'

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.resource_bundles = {
      'Q' => ['Pod/Assets/*']
    }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.source_files = 'Pod/Classes/**/*.{swift,xcdatamodeld,xcdatamodel}'
  s.dependency 'CocoaLumberjack/Swift'
  s.framework = 'CoreData'

end
