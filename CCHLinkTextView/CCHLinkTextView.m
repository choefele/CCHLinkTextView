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

    UILongPressGestureRecognizer *touchUpDownGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpDown:)];
    touchUpDownGestureRecognizer.minimumPressDuration = 0;
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

- (void)touchUpDown:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSUInteger characterIndex = [self characterIndexForGestureRecognizer:recognizer];
        [self didTouchDownAtCharacterIndex:characterIndex];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSUInteger characterIndex = [self characterIndexForGestureRecognizer:recognizer];
        [self didTouchUpAtCharacterIndex:characterIndex];
    }
}

- (void)didTouchDownAtCharacterIndex:(NSUInteger)characterIndex
{
}

- (void)didTouchUpAtCharacterIndex:(NSUInteger)characterIndex
{
}

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

- (void)textTapped:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"touch down");
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"touch up");
        NSUInteger characterIndex = [self characterIndexForGestureRecognizer:recognizer];
        BOOL linkFound = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
            [self didTapLinkAtCharacterIndex:characterIndex range:range];
        }];
        
        if (!linkFound) {
            [self linkTextViewDidTap];
        }
    }
}

- (NSUInteger)characterIndexForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    location.x -= self.textContainerInset.left;
    location.y -= self.textContainerInset.top;
    
    NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:location inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    return characterIndex;
}

- (void)addLinkForRange:(NSRange)range
{
    [self.linkRanges addObject:[NSValue valueWithRange:range]];

    NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.greenColor};
    [self addAttributes:attributes range:range];
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

- (void)addAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
    [attributedText addAttributes:attributes range:range];
    self.attributedText = attributedText;
}

@end
