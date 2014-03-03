//
//  CCHLinkTextViewDelegate.h
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCHLinkTextViewDelegate <NSObject>

@optional
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkAtCharacterIndex:(NSUInteger)characterIndex;
- (void)linkTextViewDidTap:(CCHLinkTextView *)linkTextView;

@end
