CCHLinkTextView
===============

[![Build Status](https://travis-ci.org/choefele/CCHLinkTextView.png)](https://travis-ci.org/choefele/CCHLinkTextView)&nbsp;![Version](https://cocoapod-badges.herokuapp.com/v/CCHLinkTextView/badge.png)&nbsp;![Platform](https://cocoapod-badges.herokuapp.com/p/CCHLinkTextView/badge.png)

`CCHLinkTextView` makes it easy to embed links inside a `UITextView` and receive events for short and long taps. It looks and behaves similar to table cells used in popular Twitter apps such as Twitterrific or Tweetbot.

![Animated GIF landscape]()

## Alternatives

When using iOS 7's built-in link detection via `NSLinkAttributeName`, you will find that `textView:shouldInteractWithURL:inRange:` is only called when the user presses the link for a certain amount of time. This delay is frustrating for users because they expect an app to react instantly on taps. In contrast to `UITextView`, `CCHLinkTextView` works great in `UITableView`s – even with `userInteractionEnabled` set to `YES` – because touches outside links are passed through to the `UITableView`. In addition, `CCHLinkTextView` provides events for short and long taps.

Compared to `OHAttributedLabel` and `TTTAttributeLabel`, `CCHLinkTextView` is written for iOS 7 using TextKit functionality. This makes for a simpler implementation avoiding custom drawing code using CoreText. 

In contrast to `STTweetLabel`, `CCHLinkTextView` is a subclass of `UITextView` because `UILabel` has limited TextKit support and adding this functionality can be quite hacky. `CCHLinkTextView` supports all of `UITextView`'s features and can also be used from within storyboards. Whereas `STTweetLabel` places its links on certain hotwords, you can mark any text range as a link with `CCHLinkTextView`. 

## Installation

## Usage

- By default, `CCHLinkTextView` is noneditable. Setting `isEditable` to `YES` will turn off link detection.
- Links can have custom styles 
- UIAppearance support
- NSTextChecking/data detectors

## License (MIT)
