#
# Be sure to run `pod lib lint PoporNetMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporNetMonitor'
  s.version          = '0.0.1'
  s.summary          = 'A short description of PoporNetMonitor.'
  
  s.homepage         = 'https://github.com/popor/PoporNetMonitor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporNetMonitor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PoporNetMonitor/Classes/**/*'
  
  
  #  s.subspec 'NetMonitorList' do |ss|
  #      ss.source_files = 'PoporUI/Classes/NetMonitorList/*.{h,m}'
  #  end
  

end
