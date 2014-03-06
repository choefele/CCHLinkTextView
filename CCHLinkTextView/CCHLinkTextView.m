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
#import "CCHLinkGestureRecognizer.h"

// Use subclass of UITextViewDelegate
// Replace linkRanges with NSLinkAttribute attributes

@interface CCHLinkTextView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *linkRanges;
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
    
    self.linkGestureRecognizer = [[CCHLinkGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    self.linkGestureRecognizer.delegate = self;
//    self.linkGestureRecognizer.longPressEnabled = NO;
    [self addGestureRecognizer:self.linkGestureRecognizer];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
//    [self addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)textTapped:(CCHLinkGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"touch down");
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"touch up");
        NSLog(@"touch up %@", recognizer.isLongPress ? @"Y" : @"N");
//        CGPoint location = [recognizer locationInView:self];
//        location.x -= self.textContainerInset.left;
//        location.y -= self.textContainerInset.top;
//        
//        NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:location inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
//        BOOL linkTapped = [self enumerateLinkRangesIncludingCharacterIndex:characterIndex usingBlock:^(NSRange range) {
//            [self didTapLinkAtCharacterIndex:characterIndex range:range];
//        }];
//        
//        if (!linkTapped) {
//            [self linkTextViewDidTap];
//        }
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
