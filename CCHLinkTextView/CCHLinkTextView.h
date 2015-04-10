//
//  CCHLinkTextView.h
//  CCHLinkTextView
//
//  Copyright (C) 2014 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class CCHLinkGestureRecognizer;
@protocol CCHLinkTextViewDelegate;

/** Attribute name for links. The value can by any object.*/
extern NSString *const CCHLinkAttributeName;

/** `UITextView` subclass with tappable links. */
@interface CCHLinkTextView : UITextView

/** Delegate to receive tap and long press events. */
@property (nonatomic, weak) id<CCHLinkTextViewDelegate> linkDelegate;

/** `NSAttributedString` attributes applied to links when touched. Use `linkTextAttributes` for attributes applied to links before being touched.*/
@property (nonatomic, copy) NSDictionary *linkTextTouchAttributes;

/** The minimum period fingers must press on the link for the gesture to be recognized as a long press (default = 0.5s). */
@property (nonatomic) CFTimeInterval minimumPressDuration;
/** The maximum movement of the fingers on the link before the gesture is ignored (default = 10 points). */
@property (nonatomic) CGFloat allowableMovement;

/** Expands or shrinks the tap area of the link text (default: {-5, -5, -5, -5}). */
@property (nonatomic) UIEdgeInsets tapAreaInsets;

/** The gesture recognizer used to detect links in this text view. */
@property (nonatomic, readonly) CCHLinkGestureRecognizer *linkGestureRecognizer;

/** The corner radius of the rounded rectangle that is shown when the link is touched. Set to 0
 to disable rounder corners (default = 0 points). */
@property (nonatomic) CGFloat linkCornerRadius;

/** 
 For the given ranges, enumerates all view rectangles that cover each range.
 @param ranges array of ranges.
 @param block block that's called for each view rect.
 */
- (void)enumerateViewRectsForRanges:(NSArray *)ranges usingBlock:(void (^)(CGRect rect, NSRange range, BOOL *stop))block;

/** 
 Enumerates all ranges with a link for the given point.
 @param location point in this view's coordinates.
 @param block block that's called for every link range that was found.
 */
- (BOOL)enumerateLinkRangesContainingLocation:(CGPoint)location usingBlock:(void (^)(NSRange range))block;

@end
