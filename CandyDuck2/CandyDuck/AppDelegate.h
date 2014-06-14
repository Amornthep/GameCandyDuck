//
//  AppDelegate.h
//  CandyDuck
//
//  Created by Amornthep on 2/8/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    GADBannerView *adBanner_;
    GADBannerView *bannerView_;
}

@property (strong, nonatomic) UIWindow *window;

-(void)showAds;

@end
