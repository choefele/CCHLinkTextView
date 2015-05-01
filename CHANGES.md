Changes
=======

## 1.2.0

- Changing the `CCHLinkTextView`'s `editable` property to `NO` now disables link recognition. This allows you to optionally turn on/off the functionality that provides tappable links, but then revert to normal selection/editing text behavior when desired. Thanks to patricklynch for the pull request.

## 1.1.1

- Fixed a bug where a link didn't handle touch up events correctly. Thanks to zeevvax for reporting the issue.

## 1.1.0

- New property to highlight touched links with rounded corners. Thanks to wandermyz for the pull request

## 1.0.1

- Fixed a bug where `linkTextTouchAttributes` would be ignored if `linkTextAttributes` clashed. Thanks to lukedixon for the pull request

## 1.0.0

- Initial release
