//
//  CCHLinkTextView.h
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCHLinkTextViewDelegate;
@class CCHLinkGestureRecognizer;

@interface CCHLinkTextView : UITextView

@property (nonatomic, weak) id<CCHLinkTextViewDelegate> linkDelegate;
@property (nonatomic, strong, readonly) CCHLinkGestureRecognizer *linkGestureRecognizer;

- (void)addLinkForRange:(NSRange)range;
- (BOOL)enumerateLinkRangesIncludingCharacterIndex:(NSUInteger)characterIndex usingBlock:(void (^)(NSRange range))block;

@end
