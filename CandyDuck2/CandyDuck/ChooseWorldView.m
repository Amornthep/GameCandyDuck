//
//  ChooseWorldView.m
//  CandyDuck
//
//  Created by Bike on 2/26/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "ChooseWorldView.h"

@implementation ChooseWorldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [super init];
    
    ChooseWorldView *object = [[[NSBundle mainBundle] loadNibNamed:@"ChooseWorldView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([object isKindOfClass:[ChooseWorldView class]])
    {
        object.select1Button.selected=YES;
        return object;
    }
    else
        return nil;
    
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
