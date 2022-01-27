#
# Be sure to run `pod lib lint RxNormKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxNormKit'
  s.version          = '0.1.0'
  s.summary          = 'RxNormKit is a library for embedding RxNorm codes as a Realm database.'
  s.description      = <<-DESC
  RxNormKit is a library for embedding RxNorm codes as a Realm database. The example
  application included with the library can be run on a Mac OS desktop to read RxNorm
  code files and generate a compacted Realm database that can be bundled into an iOS app.
                       DESC

  s.homepage         = 'https://github.com/peakresponse/peak-ios-rxnormkit'
  s.license          = { :type => 'LGPL', :file => 'LICENSE.md' }
  s.author           = { 'Francis Li' => 'francis@peakresponse.net' }
  s.source           = { :git => 'https://github.com/peakresponse/peak-ios-rxnormkit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.4'
  s.swift_versions = ['4.0', '4.2', '5.0']

  s.source_files = 'RxNormKit/Classes/**/*'
  s.dependency 'RealmSwift', '>=10.11.0'
end
