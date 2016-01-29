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
  s.summary          = "Persistent Queue written in swift what supports both Sqllite3 and Coredata."
  s.description      = <<-DESC
  Persistent Queue written in swift what supports both Sqllite3 and Coredata.  Uses pod subspecs
  to include the necessary backend desired.
                       DESC

  s.homepage         = "https://github.com/edwardvalentini/Q"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Edward Valentini" => "edward@interlook.com" }
  s.source           = { :git => "https://github.com/edwardvalentini/Q.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.default_subspec = 'Default'

  s.resources = ['Pod/Assets/QAssets.bundle']

  s.subspec 'Default' do |ss|
    ss.source_files = 'Pod/Classes/*.swift'
    ss.dependency 'CocoaLumberjack/Swift'
  end

  s.subspec 'FMDB' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.osx.deployment_target = '10.10'
    ss.source_files = 'Pod/Classes/FMDB/*.swift'
    ss.library = 'sqlite3'
    ss.dependency 'Q/Default'
    ss.dependency 'FMDB'
  end

  s.subspec 'CoreData' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.osx.deployment_target = '10.10'
    ss.source_files = 'Pod/Classes/CoreData/*.swift'
    ss.dependency 'Q/Default'
    ss.framework = 'CoreData'
  end

end
