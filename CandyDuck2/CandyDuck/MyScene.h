//
//  MyScene.h
//  CandyDuck
//

//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameOverView.h"
#import "ReadyGameView.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>
@import AVFoundation;

@protocol MySceneDelegate
- (void)showGameCenter:(id)sender;
- (void)shareFacebook:(id)sender;
- (void)sendScore:(int)score;
- (void)mySceneDelegate:(SKScene*)view;
@end

@interface MyScene : SKScene<SKPhysicsContactDelegate,GKGameCenterControllerDelegate,ADBannerViewDelegate,GADBannerViewDelegate>{
    GADBannerView *adBanner_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
    
    GADBannerView *bannerView_;
    SKSpriteNode *spriteDuck;
    BOOL isGameOver;
    BOOL isGameStart;
    BOOL isTestDebug;
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _lastMissileAdded;
    NSTimeInterval _lastCoinAdded;
    SKLabelNode *scoreLabel;
    SKLabelNode *heighScoreLabel;
    AVAudioPlayer* _backgroundAudioPlayer;
    int score;
    ReadyGameView* readyGameView;
    GameOverView* gameOverView;
    int countRoundCoin;
    SLComposeViewController* slComposeViewController;
    
    UIView* flatView;
    
     NSArray *duckWalkingFrames;
     NSArray *duckEndFrames;
}
@property(nonatomic,readwrite)int mapState;

@property(nonatomic,retain) id delegate;

@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;
@end
