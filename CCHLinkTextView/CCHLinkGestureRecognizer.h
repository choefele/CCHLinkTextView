//
//  CCHLinkGestureRecognizer.h
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 06.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
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
@property (nonatomic, assign) CFTimeInterval minimumPressDuration;
/** The maximum movement of the fingers on the view before the gesture gets recognized as failed (default = 10 points). */
@property (nonatomic, assign) CGFloat allowableMovement;

/** Result code of the gesture when the gesture has been recognized (state is UIGestureRecognizerStateRecognized). */
@property (nonatomic, assign, readonly) CCHLinkGestureRecognizerResult result;

@end
