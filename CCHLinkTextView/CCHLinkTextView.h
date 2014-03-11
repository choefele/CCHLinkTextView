//
//  CCHLinkTextView.h
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCHLinkTextViewDelegate;

@interface CCHLinkTextView : UITextView

@property (nonatomic, weak) id<CCHLinkTextViewDelegate> linkDelegate;
@property (nonatomic, copy) NSDictionary *linkTextTouchAttributes;

/** The minimum period fingers must press on the link for the gesture to be recognized as a long press (default = 0.5s). */
@property (nonatomic, assign) CFTimeInterval minimumPressDuration;
/** The maximum movement of the fingers on the link before the gesture is ignored (default = 10 points). */
@property (nonatomic, assign) CGFloat allowableMovement;

- (void)addLinkForRange:(NSRange)range;
//- (void)removeLinkForRange:(NSRange)range;
- (BOOL)enumerateLinkRangesIncludingCharacterIndex:(NSUInteger)characterIndex usingBlock:(void (^)(NSRange range))block;

@end
