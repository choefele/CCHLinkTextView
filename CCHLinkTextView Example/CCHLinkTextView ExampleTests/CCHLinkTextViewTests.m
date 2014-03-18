//
//  CCHLinkTextViewTests.m
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

#import <XCTest/XCTest.h>

#import "CCHLinkTextView.h"

@interface CCHLinkTextViewTests : XCTestCase

@property (nonatomic, strong) CCHLinkTextView *linkTextView;

@end

@implementation CCHLinkTextViewTests

- (void)setUp
{
    [super setUp];
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    self.linkTextView = [[CCHLinkTextView alloc] initWithFrame:rect];
    self.linkTextView.text = @"012345678901234567890123456789";
}

- (void)testEnumerateViewRectsForRanges
{
    NSValue *rangeAsValue = [NSValue valueWithRange:NSMakeRange(0, 10)];
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateViewRectsForRanges:@[rangeAsValue] usingBlock:^(CGRect rect, NSRange range, BOOL *stop) {
        blockCalled++;
    }];
    XCTAssertEqual(blockCalled, 1);
}

- (void)testEnumerateViewRectsForRangesTwice
{
    NSValue *rangeAsValue = [NSValue valueWithRange:NSMakeRange(0, 20)];
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateViewRectsForRanges:@[rangeAsValue] usingBlock:^(CGRect rect, NSRange range, BOOL *stop) {
        blockCalled++;
    }];
    XCTAssertEqual(blockCalled, 2);
}

- (void)testEnumerateViewRectsForRangesTwiceStopped
{
    NSValue *rangeAsValue = [NSValue valueWithRange:NSMakeRange(0, 20)];
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateViewRectsForRanges:@[rangeAsValue] usingBlock:^(CGRect rect, NSRange range, BOOL *stop) {
        blockCalled++;
        *stop = YES;
    }];
    XCTAssertEqual(blockCalled, 1);
}

- (void)testEnumerateLinkRangesContainingPoint
{
    NSRange linkRange = NSMakeRange(0, 10);
    [self.linkTextView addLinkForRange:linkRange];
    
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateLinkRangesContainingLocation:CGPointMake(50, 20) usingBlock:^(NSRange range) {
        blockCalled++;
        XCTAssertTrue(NSEqualRanges(range, linkRange));
    }];
    XCTAssertEqual(blockCalled, 1);
}

- (void)testEnumerateLinkRangesContainingPointTwice
{
    NSRange linkRange = NSMakeRange(0, 20);
    [self.linkTextView addLinkForRange:linkRange];
    
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateLinkRangesContainingLocation:CGPointMake(50, 20) usingBlock:^(NSRange range) {
        blockCalled++;
        XCTAssertTrue(NSEqualRanges(range, linkRange));
    }];
    XCTAssertEqual(blockCalled, 1);
}

- (void)testEnumerateLinkRangesContainingPointOverlapping
{
    [self.linkTextView addLinkForRange:NSMakeRange(0, 20)];
    [self.linkTextView addLinkForRange:NSMakeRange(5, 20)];
    
    __block NSUInteger blockCalled = 0;
    [self.linkTextView enumerateLinkRangesContainingLocation:CGPointMake(50, 20) usingBlock:^(NSRange range) {
        blockCalled++;
    }];
    XCTAssertEqual(blockCalled, 2);
}

@end
