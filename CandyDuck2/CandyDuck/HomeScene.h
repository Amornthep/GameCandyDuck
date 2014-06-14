//
//  HomeScene.h
//  CandyDuck
//
//  Created by Amornthep on 3/9/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol HomeSceneDelegate
- (void)showGameCenter:(id)sender;
- (void)shareFacebook:(id)sender;
- (void)sendScore:(int)score;
- (void)mySceneDelegate:(SKScene*)view;
- (void)openAppStore;
@end

@interface HomeScene : SKScene{
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
}

@property(nonatomic,retain) id delegate;

@end
