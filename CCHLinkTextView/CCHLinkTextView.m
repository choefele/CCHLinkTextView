//
//  CCHLinkTextView.m
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

// Based on http://stackoverflow.com/questions/19332283/detecting-taps-on-attributed-text-in-a-uitextview-on-ios-7

#import "CCHLinkTextView.h"

#import "CCHLinkTextViewDelegate.h"

// Use subclass of UITextViewDelegate
// Replace linkRanges with NSLinkAttribute attributes

@interface CCHLinkTextView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *linkRanges;
@property (nonatomic, assign) NSUInteger touchDownCharacterIndex;

@end

@implementation CCHLinkTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    self.linkRanges = [NSMutableArray array];
    self.touchDownCharacterIndex = -1;

    UILongPressGestureRecognizer *touchUpDownGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpDown:)];
    touchUpDownGestureRecognizer.minimumPressDuration = 0;
    touchUpDownGestureRecognizer.allowableMovement = 100;
    touchUpDownGestureRecognizer.delegate = self;
    [self addGestureRecognizer:touchUpDownGestureRecognizer];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGestureRecognizer.delegate = self;
    [tapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)addLinkForRange:(NSRange)range
{
    [self.linkRanges addObject:[NSValue valueWithRange:range]];
    
//    NSDictionary *attributes = @{NSForegroundColorAttributeName : UIColor.greenColor};
    [self addAttributes:self.linkTextAttributes range:range];
}

- (BOOL)enumerateLinkRangesIncludingCharacterIndex:(NSUInteger)characterIndex usingBlock:(void (^)(NSRange range))block
{
    if (!block) {
        return NO;
    }
    
    BOOL linkTapped = NO;
    
    for (NSValue *value in self.linkRanges) {
        NSRange range = value.rangeValue;
        if (NSLocationInRange(characterIndex, range)) {
            linkTapped = YES;
            block(range);
        }
    }
    
    return linkTapped;
}

- (NSUInteger)characterIndexForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    location.x -= self.textContainerInset.left;
    location.y -= self.textContainerInset.top;
    
    NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:location inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    return characterIndex;
}

- (void)addAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
    [attributedText addAttributes:attributes range:range];
    self.attributedText = attributedText;
}

#pragma mark Touch up/down

- (void)touchUpDown:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSAssert(self.touchDownCharacterIndex == -1, @"Invalid character index");
        self.touchDownCharacterIndex = [self characterIndexForGestureRecognizer:recognizer];
        [self didTouchDownAtCharacterIndex:self.touchDownCharacterIndex];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.touchDownCharacterIndex != -1, @"Invalid character index");
        [self didTouchUpAtCharacterIndex:self.touchDownCharacterIndex];
        self.touchDownCharacterIndex = -1;
    }
}

- (void)didTouchDownAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"touch down %tu", characterIndex);
    
    [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
        NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.greenColor};
        [self addAttributes:attributes range:range];
    }];
}

- (void)didTouchUpAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"touch up %tu", characterIndex);
    
    [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
        NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.clearColor};
        [self addAttributes:attributes range:range];
    }];
}

#pragma mark Long press

- (void)longPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSUInteger characterIndex = [self characterIndexForGestureRecognizer:recognizer];
        BOOL linkFound = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
            [self didLongPressLinkAtCharacterIndex:characterIndex range:range];
        }];
        
        if (!linkFound) {
            [self linkTextViewDidLongPress];
        }
    }
}

- (void)didLongPressLinkAtCharacterIndex:(NSUInteger)characterIndex range:(NSRange)range
{
    NSLog(@"long press %tu", characterIndex);
    
    if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didLongPressLinkAtCharacterIndex:)]) {
        [self.linkDelegate linkTextView:self didLongPressLinkAtCharacterIndex:characterIndex];
    }
}

- (void)linkTextViewDidLongPress
{
    if ([self.linkDelegate respondsToSelector:@selector(linkTextViewDidLongPress:)]) {
        [self.linkDelegate linkTextViewDidLongPress:self];
    }
}

#pragma mark Tap

- (void)tap:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSUInteger characterIndex = [self characterIndexForGestureRecognizer:recognizer];
        BOOL linkFound = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
            [self didTapLinkAtCharacterIndex:characterIndex range:range];
        }];
        
        if (!linkFound) {
            [self linkTextViewDidTap];
        }
    }
}

- (void)didTapLinkAtCharacterIndex:(NSUInteger)characterIndex range:(NSRange)range
{
    NSLog(@"tap %tu", characterIndex);

    if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didTapLinkAtCharacterIndex:)]) {
        [self.linkDelegate linkTextView:self didTapLinkAtCharacterIndex:characterIndex];
    }
}

- (void)linkTextViewDidTap
{
    if ([self.linkDelegate respondsToSelector:@selector(linkTextViewDidTap:)]) {
        [self.linkDelegate linkTextViewDidTap:self];
    }
}

@end
