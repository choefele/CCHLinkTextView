//
//  CCHLinkGestureRecognizerTests.m
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 06.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import "CCHLinkGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>
#import <XCTest/XCTest.h>

@interface CCHLinkGestureRecognizerTests : XCTestCase

@property (nonatomic, strong) CCHLinkGestureRecognizer *linkGestureRecognizer;

@end

@implementation CCHLinkGestureRecognizerTests

- (void)setUp
{
    [super setUp];
    
    self.linkGestureRecognizer = [[CCHLinkGestureRecognizer alloc] init];
}

- (void)testStateEnded
{
    UITouch *touch = [[UITouch alloc] init];
    NSSet *touches = [NSSet setWithObject:touch];

    [self.linkGestureRecognizer touchesBegan:touches withEvent:nil];
    XCTAssertEqual(self.linkGestureRecognizer.state, UIGestureRecognizerStateBegan);

    [self.linkGestureRecognizer touchesMoved:touches withEvent:nil];
    XCTAssertEqual(self.linkGestureRecognizer.state, UIGestureRecognizerStateBegan);

    [self.linkGestureRecognizer touchesEnded:touches withEvent:nil];
    XCTAssertEqual(self.linkGestureRecognizer.state, UIGestureRecognizerStateEnded);
}

@end
