//
//  ViewController.m
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import "ViewController.h"

#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"

@interface ViewController () <CCHLinkTextViewDelegate>

@property (weak, nonatomic) IBOutlet CCHLinkTextView *storyboardTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.storyboardTextView.editable = NO;
    
    [self.storyboardTextView addLinkForRange:NSMakeRange(0, 10)];
    [self.storyboardTextView addLinkForRange:NSMakeRange(100, 5)];
    self.storyboardTextView.linkDelegate = self;
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"Link tapped");
}

@end
