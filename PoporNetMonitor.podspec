#
# Be sure to run `pod lib lint PoporNetMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PoporNetMonitor'
    s.version          = '1.01'
    s.summary          = '主体功能灵感来自:https://github.com/HDB-Li/LLDebugTool, 只开启了debug模式,release模式不抓取网络请求'
    
    s.homepage         = 'https://github.com/popor/PoporNetMonitor'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'popor' => '908891024@qq.com' }
    s.source           = { :git => 'https://github.com/popor/PoporNetMonitor.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    s.source_files = 'PoporNetMonitor/Classes/*.{h,m}'
    
    s.dependency 'PoporFoundation/Prefix'
    s.dependency 'PoporFoundation/NSData'
    
    s.dependency 'PoporNetRecord'
    
end
