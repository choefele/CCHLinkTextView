CCHLinkTextView
===============

`CCHLinkTextView` makes it easy to embed customizable links inside a `UITextView` and add custom handlers for short and long taps. It looks and behaves similar to table cells used in popular Twitter apps such as Twitteriffic or Tweetbot.

![Animated GIF landscape]()

## Alternatives

If you try to use iOS 7's built-in link detection via `NSLinkAttributeName`, you will find that `textView:shouldInteractWithURL:inRange:` is only called when the users holds the tap for a short amount of time, which is not acceptable for highly interactive apps. Also, `CCHLinkTextView` can be easily embedded into `UITableView`s, provides handlers for short and long taps, and can use a different styling for each link.

Compared to `OHAttributedLabel` and `TTTAttributeLabel`, `CCHLinkTextView` is written for iOS 7 using TextKit functionality. This simplifies the implementation and avoids custom drawing use CoreText. 

In contrast to `STTweetLabel`, `CCHLinkTextView` is a subclass of `UITextView` because `UILabel` has limited TextKit support and adding this functionality can be quite hacky.

## Installation

## Usage

- By default, `CCHLinkTextView` is noneditable. Setting `isEditable` to `YES` will turn off link detection.
- Links can have custom styles 
- UIAppearance support
- NSTextChecking/data detectors

## License (MIT)
