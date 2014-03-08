//
//  CCHLinkGestureRecognizer.h
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 06.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 CCHLinkGestureRecognizerResultLongPress), and touch up when gesture has failed (UIGestureRecognizerStateRecognized,
 CCHLinkGestureRecognizerResultFailed).
 */
@interface CCHLinkGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CFTimeInterval minimumPressDuration;
@property (nonatomic, assign) CGFloat allowableMovement;

@property (nonatomic, assign) CCHLinkGestureRecognizerResult result;

@end
