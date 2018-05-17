#
# Be sure to run `pod lib lint UnsplashImageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UnsplashImageView'
  s.version          = '0.1.0'
  s.summary          = 'Easily embed Unsplash photos in UIImageView. Using Unsplash Source API.'

  s.description      = <<-DESC
UnsplashImageView allows to display Unsplash photos in UIImageView and make transitions between images. Using Unsplash Source API.
                       DESC

  s.homepage         = 'https://github.com/adboco/UnsplashImageView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'adboco@telefonica.net' => 'Adrián Bouza Correa' }
  s.source           = { :git => 'https://github.com/adboco/UnsplashImageView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://instagram.com/adboco'

  s.ios.deployment_target = '8.0'

  s.source_files = 'UnsplashImageView/Classes/**/*'
  s.swift_version = '4.1'

  s.frameworks = 'UIKit'
  s.dependency 'Alamofire'
  s.dependency 'Repeat'
end
