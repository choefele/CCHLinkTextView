//
//  CCHLinkGestureRecognizer.m
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 06.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import "CCHLinkGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

#define MAX_SQUARED_DISTANCE (10 * 10)

@interface CCHLinkGestureRecognizer ()

@property (nonatomic, assign) CGPoint initialPoint;
@property (nonatomic, strong) NSTimer *timer;

@end

// disable long tap

@implementation CCHLinkGestureRecognizer

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.minimumPressDuration = 0.5;
}

- (void)reset
{
    [super reset];
    
    self.result = CCHLinkGestureRecognizerResultUnknown;
    self.initialPoint = CGPointZero;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)longPressed:(NSTimer *)timer
{
    [timer invalidate];
    
    self.result = CCHLinkGestureRecognizerResultLongPress;
    self.state = UIGestureRecognizerStateRecognized;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    NSAssert(self.result == CCHLinkGestureRecognizerResultUnknown, @"Invalid result state");
    
    UITouch *touch = touches.anyObject;
    self.initialPoint = [touch locationInView:self.view];
    self.state = UIGestureRecognizerStateBegan;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.minimumPressDuration target:self selector:@selector(longPressed:) userInfo:nil repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if (![self touchIsCloseToInitialPoint:touches.anyObject]) {
        self.result = CCHLinkGestureRecognizerResultFailed;
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    if ([self touchIsCloseToInitialPoint:touches.anyObject]) {
        self.result = CCHLinkGestureRecognizerResultTap;
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.result = CCHLinkGestureRecognizerResultFailed;
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (BOOL)touchIsCloseToInitialPoint:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    CGFloat xDistance = (self.initialPoint.x - point.x);
    CGFloat yDistance = (self.initialPoint.y - point.y);
    CGFloat squaredDistance = (xDistance * xDistance) + (yDistance * yDistance);
    
    BOOL isClose = (squaredDistance <= MAX_SQUARED_DISTANCE);
    return isClose;
}

@end
