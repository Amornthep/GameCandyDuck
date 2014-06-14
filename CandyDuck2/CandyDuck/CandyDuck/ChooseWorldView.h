//
//  ChooseWorldView.h
//  CandyDuck
//
//  Created by Bike on 2/26/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseWorldView : UIView
@property (weak, nonatomic) IBOutlet UIButton *select1Button;
@property (weak, nonatomic) IBOutlet UIButton *select2Button;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *worldOne;
@property (weak, nonatomic) IBOutlet UIImageView *worldTwo;
@property (weak, nonatomic) IBOutlet UIImageView *bgSelectWorld;

@end
