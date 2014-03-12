//
//  ViewController.m
//  CCHLinkTextView Example
//

#import "ViewController.h"

#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"
#import "TextView.h"

@interface ViewController () <CCHLinkTextViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet CCHLinkTextView *linkTextView;
@property (weak, nonatomic) IBOutlet TextView *standardTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpLinkTextView:self.linkTextView];
    [self setUpStandardTextView:self.standardTextView];
}

#pragma mark - CCHLinkTextView solution

- (void)setUpLinkTextView:(CCHLinkTextView *)linkTextView
{
    linkTextView.editable = NO;
    linkTextView.selectable = NO;
    
    [linkTextView addLinkForRange:NSMakeRange(0, 10)];
    [linkTextView addLinkForRange:NSMakeRange(100, 5)];
    linkTextView.linkDelegate = self;
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"Link tapped");
}

- (void)linkTextViewDidTap:(CCHLinkTextView *)linkTextView
{
    NSLog(@"Tap");
    [self performSegueWithIdentifier:@"tableViewToDetail" sender:self];
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didLongPressLinkAtCharacterIndex:(NSUInteger)characterIndex
{
    NSLog(@"Link long pressed");
}

- (void)linkTextViewDidLongPress:(CCHLinkTextView *)linkTextView
{
    NSLog(@"Long press");
}

#pragma mark - NSLinkAttributeName solution

- (void)setUpStandardTextView:(TextView *)standardTextView
{
    standardTextView.editable = NO;
    standardTextView.viewController = self;

    NSMutableAttributedString *attributedText = [standardTextView.attributedText mutableCopy];
    if (attributedText) {
        [attributedText addAttribute:NSLinkAttributeName value:@"http://google.de" range:NSMakeRange(0, 10)];
        [attributedText addAttribute:NSLinkAttributeName value:@"Link" range:NSMakeRange(100, 5)];
        standardTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:attributedText];
    }
    standardTextView.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"Tap NSLinkAttributeName");
    return NO;
}

@end
