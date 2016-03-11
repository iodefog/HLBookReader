#
# Be sure to run `pod lib lint DYMBookReader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DYMBookReader"
  s.version          = "0.2.0"
  s.summary          = "A Shiny Reader for e-book, still under development."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
A Shiny Reader for e-book, free to use, still under development.
                       DESC

  s.homepage         = "https://github.com/dymx101/DYMBookReader"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Daniel Dong" => "dymx101@hotmail.com" }
  s.source           = { :git => "https://github.com/dymx101/DYMBookReader.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/dymx101'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DYMBookReader' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

    s.dependency 'Masonry', '~> 0.6.3'
    s.dependency 'SCPageViewController', '~> 2.0.2'
end
