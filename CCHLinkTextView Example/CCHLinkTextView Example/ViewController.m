//
//  ViewController.m
//  CCHLinkTextView Example
//

#import "ViewController.h"

#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"
#import "CCHLinkGestureRecognizer.h"

#import "TableViewCell.h"

@interface ViewController () <CCHLinkTextViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpLongPressGesture];
}

- (void)showMessage:(NSString *)message
{
    self.navigationItem.title = message;
}

#pragma mark - Table view handling

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *tableViewCell;
    
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    if (indexPath.row < (numberOfRows - 1)) {
        tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"linkTextViewCell"];
        [self setUpLinkTextView:(CCHLinkTextView *)tableViewCell.textView];
    } else {
        tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"standardTextViewCell"];
        [self setUpStandardTextView:tableViewCell.textView];
    }
    
    return tableViewCell;
}

#pragma mark - Long presses on table view cells

- (void)setUpLongPressGesture
{
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.tableView addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath) {
        NSString *message = [NSString stringWithFormat:@"Cell %zd long pressed", indexPath.row];
        [self showMessage:message];
    }
}

#pragma mark - CCHLinkAttributeName solution

- (void)setUpLinkTextView:(CCHLinkTextView *)linkTextView
{
    NSMutableAttributedString *attributedText = [linkTextView.attributedText mutableCopy];
    [attributedText addAttribute:CCHLinkAttributeName value:@"0" range:NSMakeRange(0, 20)];
    [attributedText addAttribute:CCHLinkAttributeName value:@"1" range:NSMakeRange(5, 20)];
    [attributedText addAttribute:CCHLinkAttributeName value:@"2" range:NSMakeRange(150, 40)];
    linkTextView.attributedText = attributedText;
    
    [self.longPressGestureRecognizer requireGestureRecognizerToFail:linkTextView.linkGestureRecognizer];
    linkTextView.linkDelegate = self;
    linkTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    linkTextView.linkTextTouchAttributes = @{NSBackgroundColorAttributeName : [UIColor whiteColor], NSForegroundColorAttributeName : [UIColor orangeColor]};
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value
{
    CGPoint point = [self.tableView convertPoint:linkTextView.frame.origin fromView:linkTextView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self showMessage:[NSString stringWithFormat:@"Cell %zd link %@ tapped", indexPath.row, value]];
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didLongPressLinkWithValue:(id)value
{
    CGPoint point = [self.tableView convertPoint:linkTextView.frame.origin fromView:linkTextView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self showMessage:[NSString stringWithFormat:@"Cell %zd link %@ long pressed", indexPath.row, value]];
}

#pragma mark - NSLinkAttributeName solution

- (void)setUpStandardTextView:(UITextView *)standardTextView
{
    standardTextView.editable = NO;

    NSMutableAttributedString *attributedText = [standardTextView.attributedText mutableCopy];
    [attributedText addAttribute:NSLinkAttributeName value:@"0" range:NSMakeRange(0, 20)];
    [attributedText addAttribute:NSLinkAttributeName value:@"1" range:NSMakeRange(5, 16)];
    [attributedText addAttribute:NSLinkAttributeName value:@"2" range:NSMakeRange(150, 40)];
    standardTextView.attributedText = attributedText;
    
    standardTextView.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    CGPoint point = [self.tableView convertPoint:textView.frame.origin fromView:textView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self showMessage:[NSString stringWithFormat:@"Cell %zd link %@ tapped", indexPath.row, URL]];

    return NO;
}

@end
