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

NSString *const CCHLinkAttributeName = @"CCHLinkAttributeName";
#define DEBUG_COLOR [UIColor colorWithWhite:0 alpha:0.3]

@interface CCHLinkTextView () <UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSArray *rangeValuesForTouchDown;
@property (nonatomic) CCHLinkGestureRecognizer *linkGestureRecognizer;

@end

@implementation CCHLinkTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.linkTextTouchAttributes = @{NSBackgroundColorAttributeName : UIColor.lightGrayColor};
    
    self.tapAreaInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    
    self.editable = NO;
}

- (void)setEditable:(BOOL)editable
{
    // Allows you to optionally turn on/off the functionality that provides tappable links
    // but then revert to normal selection/editing text behavior when desired.
    super.editable = editable;
    if (editable) {
        self.selectable = YES;
        [self removeGestureRecognizer:self.linkGestureRecognizer];
    } else {
        self.selectable = NO;
        if (![self.gestureRecognizers containsObject:self.linkGestureRecognizer]) {
            self.linkGestureRecognizer = [[CCHLinkGestureRecognizer alloc] initWithTarget:self action:@selector(linkAction:)];
            self.linkGestureRecognizer.delegate = self;
            [self addGestureRecognizer:self.linkGestureRecognizer];
        }
    }
}

- (id)debugQuickLookObject
{
    if (self.bounds.size.width < 0.0f || self.bounds.size.height < 0.0f) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);

    // Draw rectangles for all links
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, DEBUG_COLOR.CGColor);
    NSAttributedString *attributedString = self.attributedText;
    [attributedString enumerateAttribute:CCHLinkAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            [self enumerateViewRectsForRanges:@[[NSValue valueWithRange:range]] usingBlock:^(CGRect rect, NSRange range, BOOL *stop) {
                CGContextFillRect(context, rect);
            }];
        }
    }];

    UIGraphicsPopContext();
    
    // Draw text
    CGRect rect = self.bounds;
    rect.origin.x += self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    rect.origin.y += self.textContainerInset.top;
    [attributedString drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setLinkTextAttributes:(NSDictionary *)linkTextAttributes
{
    [super setLinkTextAttributes:linkTextAttributes];
    [self setAttributedText:self.attributedText];
}

- (void)setLinkTextTouchAttributes:(NSDictionary *)linkTextTouchAttributes
{
    _linkTextTouchAttributes = linkTextTouchAttributes;
    [self setAttributedText:self.attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSMutableAttributedString *mutableAttributedText = [attributedText mutableCopy];
    [mutableAttributedText enumerateAttribute:CCHLinkAttributeName inRange:NSMakeRange(0, attributedText.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            [mutableAttributedText addAttributes:self.linkTextAttributes range:range];
        }
    }];
    
    [super setAttributedText:mutableAttributedText];
}

- (void)enumerateViewRectsForRanges:(NSArray *)ranges usingBlock:(void (^)(CGRect rect, NSRange range, BOOL *stop))block
{
    if (!block) {
        return;
    }

    for (NSValue *rangeAsValue in ranges) {
        NSRange range = rangeAsValue.rangeValue;
        NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
        [self.layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:self.textContainer usingBlock:^(CGRect rect, BOOL *stop) {
            rect.origin.x += self.textContainerInset.left;
            rect.origin.y += self.textContainerInset.top;
            rect = UIEdgeInsetsInsetRect(rect, self.tapAreaInsets);
            
            block(rect, range, stop);
        }];
    }
}

- (BOOL)enumerateLinkRangesContainingLocation:(CGPoint)location usingBlock:(void (^)(NSRange range))block
{
    __block BOOL found = NO;
    
    NSAttributedString *attributedString = self.attributedText;
    [attributedString enumerateAttribute:CCHLinkAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (found) {
            *stop = YES;
            return;
        }
        if (value) {
            [self enumerateViewRectsForRanges:@[[NSValue valueWithRange:range]] usingBlock:^(CGRect rect, NSRange range, BOOL *stop) {
                if (found) {
                    *stop = YES;
                    return;
                }
                if (CGRectContainsPoint(rect, location)) {
                    found = YES;
                    *stop = YES;
                    if (block) {
                        block(range);
                    }
                }
            }];
        }
    }];
    
    return found;
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isEditable) {
        return [super pointInside:point withEvent:event];
    } else {
        BOOL linkFound = [self enumerateLinkRangesContainingLocation:point usingBlock:NULL];
        return linkFound;
    }
}

- (void)drawRoundedCornerForRange:(NSRange)range
{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = self.bounds;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, layer.bounds); // Unmask the whole text area
    
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
    [self.layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0) inTextContainer:self.textContainer usingBlock:^(CGRect rect, BOOL *stop) {
        rect.origin.x += self.textContainerInset.left;
        rect.origin.y += self.textContainerInset.top;
        
        CGContextClearRect(context, CGRectInset(rect, -1, -1)); // Mask the rectangle of the range
        
        CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.linkCornerRadius].CGPath);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);  // Unmask the rounded area inside the rectangle
        CGContextFillPath(context);
    }];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [layer setContents:(id)[image CGImage]];
    self.layer.mask = layer;
}

#pragma mark Gesture recognition

- (void)linkAction:(CCHLinkGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSAssert(self.rangeValuesForTouchDown == nil, @"Invalid touch down ranges");
        
        CGPoint location = [recognizer locationInView:self];
        self.rangeValuesForTouchDown = [self didTouchDownAtLocation:location];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSAssert(self.rangeValuesForTouchDown != nil, @"Invalid touch down ranges");
        
        if (recognizer.result == CCHLinkGestureRecognizerResultTap) {
            [self didTapAtRangeValues:self.rangeValuesForTouchDown];
        } else if (recognizer.result == CCHLinkGestureRecognizerResultLongPress) {
            [self didLongPressAtRangeValues:self.rangeValuesForTouchDown];
        }
        
        [self didCancelTouchDownAtRangeValues:self.rangeValuesForTouchDown];
        self.rangeValuesForTouchDown = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark Gesture handling

- (NSArray *)didTouchDownAtLocation:(CGPoint)location
{
    NSMutableArray *rangeValuesForTouchDown = [NSMutableArray array];
    [self enumerateLinkRangesContainingLocation:location usingBlock:^(NSRange range) {
        [rangeValuesForTouchDown addObject:[NSValue valueWithRange:range]];
        
        NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
        for (NSString *attribute in self.linkTextAttributes) {
            [attributedText removeAttribute:attribute range:range];
        }
        [attributedText addAttributes:self.linkTextTouchAttributes range:range];
        [super setAttributedText:attributedText];

        if (self.linkCornerRadius > 0) {
          [self drawRoundedCornerForRange:range];
        }
    }];
    
    return rangeValuesForTouchDown;
}

- (void)didCancelTouchDownAtRangeValues:(NSArray *)rangeValues
{
    NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
    for (NSValue *rangeValue in rangeValues) {
        NSRange range = rangeValue.rangeValue;
        
        for (NSString *attribute in self.linkTextTouchAttributes) {
            [attributedText removeAttribute:attribute range:range];
        }
        [attributedText addAttributes:self.linkTextAttributes range:range];
    }
    [super setAttributedText:attributedText];
    self.layer.mask = nil;
}

- (void)didTapAtRangeValues:(NSArray *)rangeValues
{
    if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didTapLinkWithValue:)]) {
        for (NSValue *rangeValue in rangeValues) {
            NSRange range = rangeValue.rangeValue;
            id value = [self.attributedText attribute:CCHLinkAttributeName atIndex:range.location effectiveRange:NULL];
            [self.linkDelegate linkTextView:self didTapLinkWithValue:value];
        }
    }
//    
//    [self enumerateLinkRangesContainingLocation:location usingBlock:^(NSRange range) {
//        if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didTapLinkWithValue:)]) {
//            id value = [self.attributedText attribute:CCHLinkAttributeName atIndex:range.location effectiveRange:NULL];
//            [self.linkDelegate linkTextView:self didTapLinkWithValue:value];
//        }
//    }];
}

- (void)didLongPressAtRangeValues:(NSArray *)rangeValues
{
    if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didLongPressLinkWithValue:)]) {
        for (NSValue *rangeValue in rangeValues) {
            NSRange range = rangeValue.rangeValue;
            id value = [self.attributedText attribute:CCHLinkAttributeName atIndex:range.location effectiveRange:NULL];
            [self.linkDelegate linkTextView:self didLongPressLinkWithValue:value];
        }
    }

//    [self enumerateLinkRangesContainingLocation:location usingBlock:^(NSRange range) {
//        if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didLongPressLinkWithValue:)]) {
//            id value = [self.attributedText attribute:CCHLinkAttributeName atIndex:range.location effectiveRange:NULL];
//            [self.linkDelegate linkTextView:self didLongPressLinkWithValue:value];
//        }
//    }];
}

@end
