//
//  CCHLinkGestureRecognizer.h
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 06.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 A discreet gesture recognizer that sends action messages for touch down 
 (UIGestureRecognizerStateBegan), touch up for a tap (UIGestureRecognizerStateRecognized,
 isLongPress == NO), and touch up for a long press (UIGestureRecognizerStateRecognized, isLongPress == NO).
 */
@interface CCHLinkGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CFTimeInterval minimumPressDuration;
@property (nonatomic, assign, readonly, getter = isLongPress) BOOL longPress;
@property (nonatomic, assign, getter = isLongPressEnabled) BOOL longPressEnabled;

@end
