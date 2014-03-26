iOS-EasyReader
===

Project Setup Instructions
---

1. Install xcode
2. Get the repo


        git clone git@github.com:cloudspace/iOS-EasyReader.git

3. Install cocoapods if it is not already setup


        gem install cocoapods
        pod setup

4.  Add the cloudspace cocoapod repo for access to some cloudspace only libraries.


        cd  ~/path/to/project
        pod repo add Cloudspace-iOS-Pods git@github.com:cloudspace/Cloudspace-iOS-PodSpecs.git
        pod install

5. Open the project in xcode using 'EasyReader.xcworkspace'.  Do not open it with 'EasyReader.xcodeproj'.
6. Build and run the project

Note that version 1 of EasyReader requires a working development environment for the Cloudspace RSS project.  Clone it and follow the instructions in the readme to set it up.

    git clone git@github.com:cloudspace/cloudspace_rss.git
