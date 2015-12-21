//
//  CCHLinkGestureRecognizer.m
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

#import "CCHLinkGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface CCHLinkGestureRecognizer ()

@property (nonatomic) CCHLinkGestureRecognizerResult result;
@property (nonatomic) CGPoint initialPoint;
@property (nonatomic) NSTimer *timer;

@end

// disable long tap

@implementation CCHLinkGestureRecognizer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // Same defaults as UILongPressGestureRecognizer
    self.minimumPressDuration = 0.5;
    self.allowableMovement = 10;
    
    self.result = CCHLinkGestureRecognizerResultUnknown;
    self.initialPoint = CGPointZero;
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
    
    BOOL isClose = (squaredDistance <= (self.allowableMovement * self.allowableMovement));
    return isClose;
}

@end
