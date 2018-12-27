# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |s|

  s.name             = 'RouteAction_Test'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RouteAction.'

  s.homepage         = 'https://github.com/ygyalone/RouteAction'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ygyalone' => 'ygy9916730@163.com' }
  s.source           = { :git => 'https://github.com/ygyalone/RouteAction.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.source_files = 'RouteAction/Classes/**/*'
  s.prefix_header_contents = '#import "RAMacro.h"'

end
