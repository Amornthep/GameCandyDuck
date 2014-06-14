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
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if (screenHeight < 500) {
            object.bgSelectWorld.frame = CGRectMake(object.bgSelectWorld.frame.origin.x-37, object.bgSelectWorld.frame.origin.y, object.bgSelectWorld.frame.size.width, object.bgSelectWorld.frame.size.height);
            object.preButton.frame = CGRectMake(object.preButton.frame.origin.x-37, object.preButton.frame.origin.y, object.preButton.frame.size.width, object.preButton.frame.size.height);
            object.nextButton.frame = CGRectMake(object.nextButton.frame.origin.x-37, object.nextButton.frame.origin.y, object.nextButton.frame.size.width, object.nextButton.frame.size.height);
            object.select1Button.frame = CGRectMake(object.select1Button.frame.origin.x-37, object.select1Button.frame.origin.y, object.select1Button.frame.size.width, object.select1Button.frame.size.height);
            object.select2Button.frame = CGRectMake(object.select2Button.frame.origin.x-37, object.select2Button.frame.origin.y, object.select2Button.frame.size.width, object.select2Button.frame.size.height);
            object.worldOne.frame = CGRectMake(object.worldOne.frame.origin.x-37, object.worldOne.frame.origin.y, object.worldOne.frame.size.width, object.worldOne.frame.size.height);
            object.worldTwo.frame = CGRectMake(object.worldTwo.frame.origin.x-37, object.worldTwo.frame.origin.y, object.worldTwo.frame.size.width, object.worldTwo.frame.size.height);
            object.playButton.frame = CGRectMake(object.playButton.frame.origin.x-37, object.playButton.frame.origin.y, object.playButton.frame.size.width, object.playButton.frame.size.height);
        }
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
