CCHLinkTextView
===============

[![Build Status](https://travis-ci.org/choefele/CCHLinkTextView.png)](https://travis-ci.org/choefele/CCHLinkTextView)

`CCHLinkTextView` makes it easy to embed customizable links inside a `UITextView` and add custom handlers for short and long taps. It looks and behaves similar to table cells used in popular Twitter apps such as Twitteriffic or Tweetbot.

![Animated GIF landscape]()

## Alternatives

When using iOS 7's built-in link detection via `NSLinkAttributeName`, you will find that `textView:shouldInteractWithURL:inRange:` is only called when the users long-presses the link for a short amount of time, which is not acceptable for highly interactive apps. `CCHLinkTextView` can be easily embedded into `UITableView`s because you can use taps not handled by links to select a table cell. In addition, it provides handlers for short and long taps and can use different text styles for each link.

Compared to `OHAttributedLabel` and `TTTAttributeLabel`, `CCHLinkTextView` is written for iOS 7 using TextKit functionality. This makes for a more efficient implementation avoiding custom drawing code using CoreText. 

In contrast to `STTweetLabel`, `CCHLinkTextView` is a subclass of `UITextView` because `UILabel` has limited TextKit support and adding this functionality can be quite hacky. `CCHLinkTextView` supports all of `UITextView`'s features and can also be used from within storyboards. Whereas `STTweetLabel` places its links on certain hotwords, you can mark any text range as a link with `CCHLinkTextView`. 

## Installation

## Usage

- By default, `CCHLinkTextView` is noneditable. Setting `isEditable` to `YES` will turn off link detection.
- Links can have custom styles 
- UIAppearance support
- NSTextChecking/data detectors

## License (MIT)
