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
    
    self.linkTextView = [[CCHLinkTextView alloc] init];
    self.linkTextView.text = @"012345678901234567890123456789";
}

- (void)testLinkRangeFound
{
    NSRange range = NSMakeRange(3, 4);
    [self.linkTextView addLinkForRange:range];
    
    __block NSUInteger blockCalled = 0;
    BOOL linkFound = [self.linkTextView enumerateLinkRangesIncludingCharacterIndex:4 usingBlock:^(NSRange range) {
        blockCalled++;
    }];
    
    XCTAssertTrue(linkFound);
    XCTAssertEqual(blockCalled, 1u);
}

- (void)testLinkRangeNotFound
{
    NSRange range = NSMakeRange(3, 4);
    [self.linkTextView addLinkForRange:range];
    
    __block NSUInteger blockCalled = 0;
    BOOL linkFound = [self.linkTextView enumerateLinkRangesIncludingCharacterIndex:1 usingBlock:^(NSRange range) {
        blockCalled++;
    }];
    
    XCTAssertFalse(linkFound);
    XCTAssertEqual(blockCalled, 0u);
}


@end
