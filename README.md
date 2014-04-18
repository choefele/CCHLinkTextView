CCHLinkTextView
===============

[![Build Status](https://travis-ci.org/choefele/CCHLinkTextView.png)](https://travis-ci.org/choefele/CCHLinkTextView)&nbsp;![Version](https://cocoapod-badges.herokuapp.com/v/CCHLinkTextView/badge.png)&nbsp;![Platform](https://cocoapod-badges.herokuapp.com/p/CCHLinkTextView/badge.png)

`CCHLinkTextView` makes it easy to embed links inside a `UITextView` and receive events for short and long taps. It looks and behaves similar to table cells used in popular Twitter apps such as Twitterrific or Tweetbot. `CCHLinkTextView` is available under the MIT license.

Need to talk to a human? [Follow @claushoefele on Twitter](https://twitter.com/claushoefele).

## Alternatives

When using iOS 7's built-in link detection via `NSLinkAttributeName`, you will find that `textView:shouldInteractWithURL:inRange:` is only called when the user presses the link for a certain amount of time. This delay is frustrating for users because they expect an app to react instantly on taps.

![CCHLinkTextView demo](CCHLinkTextView.gif)

In contrast to `UITextView`, `CCHLinkTextView` works great in `UITableView`s – even with `userInteractionEnabled` set to `YES` – because touches outside links are passed through to the `UITableView`. In addition, `CCHLinkTextView` provides events for short and long taps.

Compared to `OHAttributedLabel` and `TTTAttributeLabel`, `CCHLinkTextView` is written for iOS 7 using TextKit functionality. This makes for a simpler implementation avoiding custom drawing code using CoreText. 

In contrast to `STTweetLabel`, `CCHLinkTextView` is a subclass of `UITextView` because `UILabel` has limited TextKit support and adding this functionality can be quite hacky. `CCHLinkTextView` supports all of `UITextView`'s features and can also be used from within storyboards. Whereas `STTweetLabel` places its links on certain hotwords, you can mark any text range as a link with `CCHLinkTextView`. 

## Usage

### Installation

Use [CocoaPods](http://cocoapods.org) to integrate `CCHLinkTextView` into your project. Minimum deployment target is iOS 7.0 because this project uses Text Kit functionality.

```ruby
platform :ios, '7.0'
pod "CCHLinkTextView"
```

### Creating `CCHLinkTextView`s

A `CCHLinkTextView` can be created manually via `initWithFrame:` or inside a storyboard. By default, it is non-editable and non-selectable as this would interfere with the link gestures. Otherwise, a `CCHLinkTextView` behaves like a `UITextView`.

### Setting up links

Text can be marked as a link by adding the attribute `CCHLinkAttributeName` to the range of the link:

```Obj-C
NSMutableAttributedString *attributedText = [linkTextView.attributedText mutableCopy];
[attributedText addAttribute:CCHLinkAttributeName value:@"0" range:NSMakeRange(0, 20)];
linkTextView.attributedText = attributedText;
```

If you have code using `NSLinkAttributeName`, you can simply replace this attribute with `CCHLinkAttributeName`.

The `value` can be anything you want and will be provided when the link fires (see below).

### Receiving link gestures

### Embedding `CCHLinkTextView`s into table view cells

## License (MIT)

Copyright (C) 2014 Claus Höfele

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
