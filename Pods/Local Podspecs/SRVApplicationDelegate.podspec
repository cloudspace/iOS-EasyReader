Pod::Spec.new do |s|
  s.name         = "SRVApplicationDelegate"
  s.version      = "0.0.1"
  s.summary      = "A service-oriented application delegate."
  s.homepage     = "https://github.com/jlorich/SRVApplicationDelegate.git"
  s.license      = "MIT"
  s.author             = { "Joey Lorich" => "joseph@lorich.me" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/jlorich/SRVApplicationDelegate.git", :tag => s.version.to_s }
  s.source_files  = "SRVApplicationDelegate", "SRVApplicationDelegate/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'MAObjCRuntime', '~> 0.0'
end
