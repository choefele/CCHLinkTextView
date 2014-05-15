//
//  CCHLinkGestureRecognizer.h
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

/** Type of result of the gesture in state UIGestureRecognizerStateRecognized. */
typedef enum {
    CCHLinkGestureRecognizerResultUnknown,
    CCHLinkGestureRecognizerResultTap,
    CCHLinkGestureRecognizerResultLongPress,
    CCHLinkGestureRecognizerResultFailed
} CCHLinkGestureRecognizerResult;

/** 
 A discreet gesture recognizer that sends action messages for touch down 
 (UIGestureRecognizerStateBegan), touch up for a tap (UIGestureRecognizerStateRecognized,
 CCHLinkGestureRecognizerResultTap), touch up for a long press (UIGestureRecognizerStateRecognized,
 CCHLinkGestureRecognizerResultLongPress), and touch up when the gesture has failed 
 (UIGestureRecognizerStateRecognized, CCHLinkGestureRecognizerResultFailed).
 */
@interface CCHLinkGestureRecognizer : UIGestureRecognizer

/** The minimum period fingers must press on the view for the gesture to be recognized as a long press (default = 0.5s). */
@property (nonatomic) CFTimeInterval minimumPressDuration;
/** The maximum movement of the fingers on the view before the gesture gets recognized as failed (default = 10 points). */
@property (nonatomic) CGFloat allowableMovement;

/** Result code of the gesture when the gesture has been recognized (state is UIGestureRecognizerStateRecognized). */
@property (nonatomic, readonly) CCHLinkGestureRecognizerResult result;

@end
