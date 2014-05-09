iOS-EasyReader
===

Project Setup Instructions
---

1. Install xcode
2. Get the repo


        git clone https://github.com/cloudspace/iOS-EasyReader

3. Install cocoapods if it is not already setup


        gem install cocoapods
        pod setup

4.  Add the cloudspace cocoapod repo for access to some cloudspace only libraries.


        cd  ~/path/to/project
        pod repo add Cloudspace-iOS-Pods https://github.com/cloudspace/Cloudspace-iOS-PodSpecs
        pod install

5. Open the project in xcode using 'EasyReader.xcworkspace'.  Do not open it with 'EasyReader.xcodeproj'.

6. Build and run the project
