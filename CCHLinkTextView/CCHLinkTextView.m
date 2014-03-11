//
//  CCHLinkTextView.m
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

// Based on http://stackoverflow.com/questions/19332283/detecting-taps-on-attributed-text-in-a-uitextview-on-ios-7

#import "CCHLinkTextView.h"

#import "CCHLinkTextViewDelegate.h"
#import "CCHLinkGestureRecognizer.h"

@interface CCHLinkTextView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *linkRanges;
@property (nonatomic, assign) NSUInteger touchDownCharacterIndex;
@property (nonatomic, strong) CCHLinkGestureRecognizer *linkGestureRecognizer;

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
    
    self.linkGestureRecognizer = [[CCHLinkGestureRecognizer alloc] initWithTarget:self action:@selector(linkAction:)];
    self.linkGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.linkGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)addLinkForRange:(NSRange)range
{
    [self.linkRanges addObject:[NSValue valueWithRange:range]];
    
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

- (void)setMinimumPressDuration:(CFTimeInterval)minimumPressDuration
{
    self.linkGestureRecognizer.minimumPressDuration = minimumPressDuration;
}

- (CFTimeInterval)minimumPressDuration
{
    return self.linkGestureRecognizer.minimumPressDuration;
}

- (void)setAllowableMovement:(CGFloat)allowableMovement
{
    self.linkGestureRecognizer.allowableMovement = allowableMovement;
}

- (CGFloat)allowableMovement
{
    return self.linkGestureRecognizer.allowableMovement;
}

#pragma mark Gesture recognition

- (void)linkAction:(CCHLinkGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSAssert(self.touchDownCharacterIndex == -1, @"Invalid character index");
        self.touchDownCharacterIndex = [self characterIndexForGestureRecognizer:recognizer];
        [self didTouchDownAtCharacterIndex:self.touchDownCharacterIndex];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.touchDownCharacterIndex != -1, @"Invalid character index");
        NSUInteger characterIndex = self.touchDownCharacterIndex;
        
        if (recognizer.result == CCHLinkGestureRecognizerResultTap) {
            BOOL linkFound = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
                [self didTapLinkAtCharacterIndex:characterIndex range:range];
            }];
            
            if (!linkFound) {
                [self linkTextViewDidTap];
            }
        } else if (recognizer.result == CCHLinkGestureRecognizerResultLongPress) {
            BOOL linkFound = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
                [self didLongPressLinkAtCharacterIndex:characterIndex range:range];
            }];
            
            if (!linkFound) {
                [self linkTextViewDidLongPress];
            }
        }
        
        [self didCancelTouchDownAtCharacterIndex:characterIndex];
        self.touchDownCharacterIndex = -1;
    }
}

#pragma mark Gesture handling

- (void)didTouchDownAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"touch down %tu", characterIndex);
    
    [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
        NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.greenColor};
        [self addAttributes:attributes range:range];
    }];
}

- (void)didCancelTouchDownAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"touch down canceled %tu", characterIndex);
    
    [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
        NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.clearColor};
        [self addAttributes:attributes range:range];
    }];
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
