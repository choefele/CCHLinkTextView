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
//@property (nonatomic, copy) NSDictionary *linkTextTouchDownAttributes;

/** The minimum period fingers must press on the view for the gesture to be recognized as a long press (default = 0.5s). */
@property (nonatomic, assign) CFTimeInterval minimumPressDuration;
/** The maximum movement of the fingers on the view before the gesture gets recognized as failed (default = 10 points). */
@property (nonatomic, assign) CGFloat allowableMovement;

- (void)addLinkForRange:(NSRange)range;
//- (void)removeLinkForRange:(NSRange)range;

//- (void)setLinkTextAttributes:(NSDictionary *)attributes forRange:(NSRange)range;
//- (void)removeLinkTextAttributesForRange:(NSRange)range;
//- (void)setLinkTextTouchDownAttributes:(NSDictionary *)attributes forRange:(NSRange)range;
//- (void)removeLinkTextTouchDownAttributesForRange:(NSRange)range;

- (BOOL)enumerateLinkRangesIncludingCharacterIndex:(NSUInteger)characterIndex usingBlock:(void (^)(NSRange range))block;

@end
