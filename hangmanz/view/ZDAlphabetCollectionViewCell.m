//
//  ZDAlphabetCollectionViewCell.m
//  hangmanz
//
//  Created by Jorge Moura on 02/11/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDAlphabetCollectionViewCell.h"

@interface ZDAlphabetCollectionViewCell ()

@property(weak) IBOutlet UILabel *mainLabel;

@end



@implementation ZDAlphabetCollectionViewCell


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
//---------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Lifecycle
//---------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIColor *bColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    
    [[self layer] setBorderColor:[bColor CGColor]];
    [[self layer] setBorderWidth:1.5];    
}

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Public Methods
//---------------------------------------------------------------------------------------
- (void)mainText:(NSString *)text {
    
    [[self mainLabel] setText:text];
}

- (void)color:(UIColor *)color {
    
    [self setBackgroundColor:nil];
    [self setBackgroundColor:color];
}

- (void)borderColor:(UIColor *)color {
    
    [[self layer] setBorderColor:[[UIColor redColor] CGColor]];
}



- (NSString *)description {
    
    return [NSString stringWithFormat:@"Main letter: %@", [[self mainLabel] text]];
}


@end
