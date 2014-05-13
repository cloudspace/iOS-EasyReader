Pod::Spec.new do |s|
  s.name         = "APIKit"
  s.version      = "0.0.1"
  s.summary      = "A toolkit to help with API interfaceing."
  s.homepage     = "https://github.com/jlorich/APIKit.git"
  s.license      = "MIT"
  s.author       = { "Joseph Lorich" => "joseph@lorich.me" }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/jlorich/APIKit.git", :tag => s.version.to_s }
  s.source_files  = "APIKit", "APIKit/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0.3'
  s.dependency 'Inflections', '~> 1.0.0'
  s.dependency 'MAObjCRuntime', '~> 0.0.1'
  s.dependency 'MagicalRecord', :git => 'https://github.com/magicalpanda/MagicalRecord', :commit => '98ec121bf767c495a2e887adeade7383b74a62f4'
end
