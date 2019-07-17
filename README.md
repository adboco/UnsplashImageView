# UnsplashImageView

[![Version](https://img.shields.io/cocoapods/v/UnsplashImageView.svg?style=flat)](https://cocoapods.org/pods/UnsplashImageView)
[![License](https://img.shields.io/cocoapods/l/UnsplashImageView.svg?style=flat)](https://cocoapods.org/pods/UnsplashImageView)
[![Platform](https://img.shields.io/cocoapods/p/UnsplashImageView.svg?style=flat)](https://cocoapods.org/pods/UnsplashImageView)
[![Swift Version](https://img.shields.io/badge/swift-4.1-orange.svg)](https://cocoapods.org/pods/UnsplashImageView)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fadboco%2FUnsplashImageView.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fadboco%2FUnsplashImageView?ref=badge_shield)

__UnsplashImageView__ allows to display _Unsplash_ photos in UIImageView and make transitions between images. It uses [Unsplash Source API](https://source.unsplash.com).

<p align="center">
	<img src="https://github.com/adboco/UnsplashImageView/blob/master/Assets/unsplash_demo.gif" height="600px" />
</p>

## Requirements

* Xcode 9.0+
* iOS 8.0+

## Installation

UnsplashImageView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UnsplashImageView'
```

## Usage

```swift
import UnsplashImageView
```

__With default configuration__

```swift
UnsplashConfig.default.query = .random(featured: true) // Query to Unsplash. Default is `.random(featured: false)`.
UnsplashConfig.default.size = CGSize(width: 600, height: 600) // Specifies the size of images. Default is `nil`.
UnsplashConfig.default.terms = ["fruit", "vegan"] // Search terms. Default is `nil`.
UnsplashConfig.default.mode = .gallery(interval: 10.0, transition: .fade(0.5)) // Image loading mode. Default is `single`.
UnsplashConfig.default.fixed = .none
```

__Start getting images__

```swift
let imageView = UIImageView()
// ...
imageView.unsplash.start()
```

__Stop getting images (if `gallery` mode enabled)__

```swift
imageView.unsplash.stop()
```

__With custom configuration__

```swift
var config = UnsplashConfig()

config.query = .randomFromUser(username: "ari_spada")
config.mode = .single(transition: .none)
config.fixed = .daily

imageView.unsplash.start(with: config)
```

### Modes

* `single`. Get a single image.
* `gallery`. Get a new image every __x__ seconds.

### Queries

* `photo(id: String)`. Get a specific photo by id.
* `random(featured: Bool)`. Get a random photo from Unsplash. If `featured` is `true`, it gets it from curated collections.
* `randomFromUser(username: String)`. Get a random photo from a specific user.
* `randomFromUserLikes(username: String)`. Get a random photo from a user's likes.
* `randomFromCollection(id: String)`. Get a random photo from a specific collection.

### Updates

* `none`. Always request a new photo. Default value.
* `daily`. Returns the same photo during a day for the same query.
* `weekly`. Returns the same photo during a week for the same query.

## Author

adboco@telefonica.net, Adrián Bouza Correa

## License

UnsplashImageView is available under the MIT license. See the LICENSE file for more info.


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fadboco%2FUnsplashImageView.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fadboco%2FUnsplashImageView?ref=badge_large)