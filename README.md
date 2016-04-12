# BSQRCodeReader

[![CI Status](http://img.shields.io/travis/Bobby Stenly/BSQRCodeReader.svg?style=flat)](https://travis-ci.org/Bobby Stenly/BSQRCodeReader)
[![Version](https://img.shields.io/cocoapods/v/BSQRCodeReader.svg?style=flat)](http://cocoapods.org/pods/BSQRCodeReader)
[![License](https://img.shields.io/cocoapods/l/BSQRCodeReader.svg?style=flat)](http://cocoapods.org/pods/BSQRCodeReader)
[![Platform](https://img.shields.io/cocoapods/p/BSQRCodeReader.svg?style=flat)](http://cocoapods.org/pods/BSQRCodeReader)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BSQRCodeReader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BSQRCodeReader"
```

## How To Use

To use this reader, add a custom UIView to your View Controller then change the UIView class and module to `BSQRCodeReader`. As usual, you can make an outlet in your controller. See the code below : 

```swift
@IBOutlet weak var reader: BSQRCodeReader!

override func viewDidLoad() {
    super.viewDidLoad()
    self.reader.delegate = self
}

override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.reader.startScanning()
}

```
Now you are one step away before you can read QR Code from your app. The last thing, add BSQRCodeReaderDelegate to your UIViewController class and write down your code in `func didCaptureQRCodeWithContent(content: String) -> Bool`.

```swift
func didCaptureQRCodeWithContent(content: String) -> Bool {
    //do something with your QR Code content
    // return true if you want to stop the scanning 
    // return false if you want to continue the scanning
    return true
}
```


## Author

Bobby Stenly, iceman.bsi@gmail.com

## License

BSQRCodeReader is available under the MIT license. See the LICENSE file for more info.
