//
//  TextView.m
//  Stolpersteine
//
//  Created by Claus Höfele on 03.03.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "TextView.h"

@implementation TextView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.viewController performSegueWithIdentifier:@"tableViewToDetail" sender:self];
}

@end
