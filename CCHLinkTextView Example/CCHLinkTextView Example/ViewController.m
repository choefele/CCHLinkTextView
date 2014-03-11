//
//  ViewController.m
//  CCHLinkTextView Example
//

#import "ViewController.h"

#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"

@interface ViewController () <CCHLinkTextViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet CCHLinkTextView *storyboardTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.storyboardTextView.editable = NO;
    self.storyboardTextView.selectable = NO;
    
    [self.storyboardTextView addLinkForRange:NSMakeRange(0, 10)];
    [self.storyboardTextView addLinkForRange:NSMakeRange(100, 5)];
    self.storyboardTextView.linkDelegate = self;
    
//    NSMutableAttributedString *attributedText = [self.storyboardTextView.attributedText mutableCopy];
//    if (attributedText) {
//        [attributedText addAttribute:NSLinkAttributeName value:@"http://google.de" range:NSMakeRange(0, 10)];
//        [attributedText addAttribute:NSLinkAttributeName value:@"Link" range:NSMakeRange(100, 5)];
//        self.storyboardTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:attributedText];
//    }
//    self.storyboardTextView.delegate = self;
//    
//    NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.greenColor, NSForegroundColorAttributeName : UIColor.redColor};
//    self.storyboardTextView.linkTextAttributes = attributes;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"%@", URL);
    return NO;
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

@end
