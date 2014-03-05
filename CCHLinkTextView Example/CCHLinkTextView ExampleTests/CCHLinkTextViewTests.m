//
//  CCHLinkTextViewTests.m
//  CCHLinkTextView Example
//
//  Created by Hoefele, Claus on 05.03.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
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
