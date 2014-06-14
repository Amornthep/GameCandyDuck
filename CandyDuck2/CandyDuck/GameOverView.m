//
//  GameOverView.m
//  CandyDuck
//
//  Created by Amornthep on 2/23/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "GameOverView.h"

@implementation GameOverView

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
    
    GameOverView *object = [[[NSBundle mainBundle] loadNibNamed:@"GameOverView" owner:nil options:nil] lastObject];
    

    
    // make sure customView is not nil or the wrong class!
    if ([object isKindOfClass:[GameOverView class]])
    {
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
