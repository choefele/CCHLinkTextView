//
//  EditViewController.m
//  CCHLinkTextView Example
//
//  Created by Tim Kelly on 8/8/14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"

#import "EditViewController.h"

/** Demonstration on how to use a CCHLinkTextVeiw while editing live text and updating attributes for specific search terms and link them to wikipedia */
@interface EditViewController () <CCHLinkTextViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet CCHLinkTextView *editTextView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) NSSet *ingreedientList;

@end

@implementation EditViewController

@synthesize ingreedientList = _ingreedientList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ingreedientList = [NSSet setWithObjects:@"eggs", @"bacon", @"spinach", @"milk", @"capers", @"tomatoes", @"pepper", @"salt", @"cheese", @"onions", @"ham", nil];
    
    self.editTextView.text = @"This is a CCHLinkTextView with text that will be dynamically linked as you type. This will attribute the ingreedients of an omlette: eggs, bacon (lots of bacon!), spinach, cheese, milk, capers, tomatoes, pepper, salt.";
    
    self.editTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.editTextView.layer.borderWidth = 1.0f;
    
    self.editTextView.delegate = self;
    
    [self setUpLinkTextView:self.editTextView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editModeButtonTapped:(id)sender {
    
    if (self.editTextView.isEditing){
        [self.editTextView resignFirstResponder];
        self.editTextView.isEditing = NO;
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        [self.editTextView becomeFirstResponder];
        self.editTextView.isEditing = YES;
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    
}


#pragma mark - CCHLinkAttributeName solution

- (void)setUpLinkTextView:(CCHLinkTextView *)linkTextView
{
    self.editTextView.editable = YES;
    self.editTextView.selectable = YES;
    self.editTextView.userInteractionEnabled = YES;
    
    // Here we re-create the attributed text everytime we need to refresh the attributes in case the text changes.
    // There is likely a much more efficient way to do this, but for small demonstration purposes this certainly works.
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:linkTextView.text];
    
    NSArray *ranges = [self searchRangesForText:linkTextView.text];
    
    NSRange currCursor = linkTextView.selectedRange;
    
    for (NSValue *val in ranges){
        
        NSRange currRange;
        [val getValue:&currRange];
        NSString *substring = [attributedText.string substringWithRange:currRange];
        [attributedText addAttribute:CCHLinkAttributeName value:substring range:currRange];
    }
    
    linkTextView.attributedText = attributedText;
    
    linkTextView.linkDelegate = self;
    linkTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    linkTextView.linkTextTouchAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    
    [linkTextView setSelectedRange:currCursor];
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value
{
    NSLog(@"Tapped %@", value);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", value]];
    
    [[UIApplication sharedApplication] openURL:url];
    
    [self.editTextView resignFirstResponder];
    
}

- (void)linkTextView:(CCHLinkTextView *)linkTextView didLongPressLinkWithValue:(id)value
{
    NSLog(@"Long Pressed %@", value);
    [self.editTextView resignFirstResponder];
}

#pragma mark utils

/** Returns an array of NSValue objects, which wrap NSRage structs
 */
- (NSArray *)searchRangesForText:(NSString *)searchText{
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    //NSArray *searchTerms = [searchText componentsSeparatedByString:@" "];
    NSCharacterSet *charsToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSArray *searchTerms = [searchText componentsSeparatedByCharactersInSet:charsToRemove];
    
    for (NSString *term in searchTerms){
        
        if ([self.ingreedientList containsObject:term]){
            
            // We have a match so we can attribute the text.
            NSArray *ranges = [self rangesOfString:term inString:searchText];
            
            //NSValue * val = [NSValue valueWithRange:range];
            [rangeArray addObjectsFromArray:ranges];
            
        }
        
    }
    
    return rangeArray;
    
}

/** 
    Tip from http://stackoverflow.com/questions/9667276/about-attributestring-making-multiple-occurrences-bold
    so we can find multiple occurrences of a string in order to create multiple ranges.
    
    @param searchTerm - The search term we want to search with.
    @param fullStringToSearch - The full string we want to find ranges in
 
    @return Array of NSValue objects stuffed with NSRange objects.
 */
- (NSArray *)rangesOfString:(NSString *)searchTerm inString:(NSString *)fullStringToSearch {
    
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [fullStringToSearch length]);
    NSRange range;
    while ((range = [fullStringToSearch rangeOfString:searchTerm options:0 range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [fullStringToSearch length] - NSMaxRange(range));
    }
    return results;
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;{
    
    //NSLog(@"did begin editing: %@)", textView.text);
    [self setUpLinkTextView:(CCHLinkTextView *)textView];
    
}



@end
