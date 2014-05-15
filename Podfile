platform :ios, '7.0'

link_with ['Development', 'Staging', 'Production']

# Hide cocoapods project warnings
inhibit_all_warnings!


# Cocopods public repo


pod 'MFSideMenu', '~> 0.5.4'

pod 'MagicalRecord',  '~> 2.2'
pod 'CCARadialGradientLayer', :git => 'https://github.com/jilouc/CCARadialGradientLayer', :commit => '4a2d6f31d8a08a3150ca517f0370e59047dae0e2'

pod 'AFNetworking', '~> 2.0.3'

pod 'Block-KVO', '~> 2.2.1'
pod 'NSDate+TimeAgo', '~> 1.0.2'

# User notification
pod 'SVProgressHUD', '~> 1.0'
pod 'TSMessages', '~> 0.9'
pod 'NJKWebViewProgress', '~> 0.2'


# Image caching and processing
pod 'SDWebImage', '~> 3.5.1'
pod 'GPUImage', '~> 0.1'

# Private CS repos
pod 'CSEnhancedTableView', '~> 0.0.1'
pod 'CSStandardViewControllers', '~> 0.0.1'
pod 'CSShortcuts', '~> 0.0.1'


# Analytics
pod 'GoogleAnalytics-iOS-SDK', '~> 3.0'


pod 'CLDSocialShareToolbar', git: 'https://github.com/cloudspace/CLDSocialShareToolbar', tag: '0.0.1'
pod 'SRVApplicationDelegate', git: 'https://github.com/jlorich/SRVApplicationDelegate', tag: '0.0.1'
pod 'APIKit', git: 'https://github.com/jlorich/APIKit', tag: '0.0.1'
pod 'CLDCommon', git: 'https://github.com/cloudspace/CLDCommon', tag: '0.0.1'


target :'EasyReader - Unit Tests', exclusive: true do
  pod 'OCMock', '~> 2.2.2'
end

target :Staging do
  pod 'TestFlightSDK', '~> 2.2.0-noadid-beta'
end
