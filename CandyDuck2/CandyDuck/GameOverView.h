//
//  GameOverView.h
//  CandyDuck
//
//  Created by Amornthep on 2/23/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GADBannerView.h"

@interface GameOverView : UIView{
    GADBannerView *bannerView_;
}
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectMapButton;
@property (strong, nonatomic) IBOutlet UIImageView *scoreNewImage;
@property (strong, nonatomic) IBOutlet UIButton *gamecenterButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;



@end
