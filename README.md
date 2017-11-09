# SwiftChartView
[![Version](https://img.shields.io/cocoapods/v/SwiftChartView.svg?style=flat)](http://cocoapods.org/pods/SwiftChartView)
[![License](https://img.shields.io/cocoapods/l/SwiftChartView.svg?style=flat)](http://cocoapods.org/pods/SwiftChartView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftChartView.svg?style=flat)](http://cocoapods.org/pods/SwiftChartView)

A set of chart views written in Swift.

<img src="https://github.com/derekcoder/SwiftChartView/blob/master/SwiftChartViewDemo/line_demo.gif">
<img src="https://github.com/derekcoder/SwiftChartView/blob/master/SwiftChartViewDemo/bar_demo.gif">
<img src="https://github.com/derekcoder/SwiftChartView/blob/master/SwiftChartViewDemo/scatter_demo.gif">

## Features

- [x] Line Chart View
- [x] Bar Chart View
- [x] Scatter Chart View
- [ ] Pie Chart View

## Requirements

- iOS 10.0+
- Swift 4

## Installation

### CocoaPods

```ruby
pod 'SwiftChartView'
```

## Usage

### Programmatically

```swift
import SwiftChartView

let frame = CGRect(x: 0, y: 80, width: 734, height: 240)
let chartView = LineChartView(frame: frame)
view.addSubview(chartView)
chartView.strokeChart(animated: true)
```

### IB (storyboard)

- Set Class
<img src="https://github.com/derekcoder/SwiftChartView/blob/master/SwiftChartViewDemo/setclass.png">

- Change attributes
<img src="https://github.com/derekcoder/SwiftChartView/blob/master/SwiftChartViewDemo/attributes.png">


## Contact

- [Blog](http://blog.derekcoder.com)
- [Twitter](https://twitter.com/derekcoder_)
- [Weibo](https://weibo.com/u/6155322764)
- Email: derekcoder@gmail.com

## License

SwiftChartView is released under the MIT license. [See LICENSE](https://github.com/derekcoder/SwiftChartView/blob/master/LICENSE) for details.

