Pod::Spec.new do |s|
  s.name         = "CLDSocialShareToolbar"
  s.version      = "0.0.1"
  s.summary      = "A social sharing toolbar."
  s.homepage     = "https://github.com/cloudspace/CLDSocialShareToolbar.git"
  s.license      = "MIT"
  s.author       = { "Joseph Lorich" => "joey@cloudspace.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/cloudspace/CLDSocialShareToolbar.git", :tag => s.version.to_s }
  s.source_files  = "CLDSocialShareToolbar", "CLDSocialShareToolbar/**/*.{h,m}"
  s.requires_arc = true
  s.frameworks    = 'Social', 'MessageUI'
end
