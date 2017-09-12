# On The Map
> An app that posts user-generated location information to a shared map, pulling the locations of fellow Udacity Nanodegree students, with custom messages about themselves or their learning experience.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url] 
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

The On The Map app allows users to share their location and a URL with their fellow students. To visualize this data, On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves “on the map,” so to speak. 

First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other students. These links can point to any URL that a student chooses.

After viewing the information posted by other students, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Costa Rica” or “Seattle, WA.”

![otm_01](https://user-images.githubusercontent.com/17869297/30347676-dcea3f3e-97da-11e7-944b-0fb55cc26940.jpg)
![otm_02](https://user-images.githubusercontent.com/17869297/30347680-dcf2d5e0-97da-11e7-8d1d-aca7af69bbd8.jpg)
![otm_03](https://user-images.githubusercontent.com/17869297/30347679-dcec9eaa-97da-11e7-9381-4b4c5308750c.jpg)
![otm_04](https://user-images.githubusercontent.com/17869297/30347678-dcebe49c-97da-11e7-98ca-758e0a7b0fcb.jpg)
![otm_05](https://user-images.githubusercontent.com/17869297/30347677-dcebd77c-97da-11e7-86b2-d97f523d7ae6.jpg)


## Features

- [x] Swift
- [x] User Interface created with UIKit
- [x] Multiple network request to different servers using URLSession requests for login confirmation and data for the map. 
- [x] JSON Parsing of relavent network request results.
- [x] Utilize MKMapviews, to display student data.

## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

## Usage
On The Map is written in Swift 3. You can download it and run it in any version of Xcode and Simulator.

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request.

## Meta

Your Name – erikuecke@gmail.com

[https://github.com/erikuecke](https://github.com/erikuecke)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/

[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
<!-- [codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com -->