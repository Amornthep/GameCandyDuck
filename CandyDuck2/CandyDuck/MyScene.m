//
//  MyScene.m
//  CandyDuck
//
//  Created by Amornthep on 2/8/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "YMCPhysicsDebugger.h"
#import "ViewController.h"
#import "ChooseWorldScene.h"
#import "AppDelegate.h"
#import "HomeScene.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
static const uint32_t duckCategory     =  0x1 << 0;
static const uint32_t allTargetCategory        =  0x1 << 1;
static const uint32_t airFlorCategory        =  0x1 << 2;
static const uint32_t coinCategory        =  0x1 << 3;
static const uint32_t itemCategory        =  0x1 << 4;

static const float BG_VELOCITY = 100.0;
static const float BG_GROUND_VELOCITY = 160.0;
static const float OBJECT_VELOCITY = 160.0;
#define HIGH_SCORE_KEY @"heighScore"
#define FOREST_MAP 1
#define GHOST_MAP 2
#define ICE_MAP 3
#define ITEM_RANG 7
#define WALKING_DUCK_KEY @"walkingDuck"
#define ENDING_DUCK_KEY @"endingDuck"
@implementation MyScene
@synthesize gAdBannerView,iAdBannerView;

HomeScene * homeScene;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        score=0;
        //        self.mapState = 1;
        //Init the PhysicsDebugger
        //        [YMCPhysicsDebugger init];
        
        //world gravity
        self.physicsWorld.gravity = CGVectorMake(0.0f, -5.5f);
        self.physicsWorld.contactDelegate = self;
        
      
        isGameOver = NO;
        isGameStart = NO;
        
        countRoundCoin = 1;
        
        [self performSelector:@selector(addReadyGameView) withObject:nil afterDelay:0.5];
    }
    return self;
}

-(void)walkingDuck
{
    //This is our general runAction method to make our bear walk.
    [spriteDuck runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:duckWalkingFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES]] withKey:WALKING_DUCK_KEY];
    return;
}
-(void)endingDuck
{
    if ([spriteDuck actionForKey:WALKING_DUCK_KEY]) {
        //stop just the moving to a new location, but leave the walking legs movement running
        [spriteDuck removeActionForKey:WALKING_DUCK_KEY];
    } //1
    //This is our general runAction method to make our bear walk.
    [spriteDuck runAction:[SKAction repeatActionForever:
                           [SKAction animateWithTextures:duckEndFrames
                                            timePerFrame:0.1f
                                                  resize:NO
                                                 restore:YES]] withKey:ENDING_DUCK_KEY];
    return;
}
-(void) willMoveFromView:(SKView *)view
{
//    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        SKNode* child = obj;
//        [child removeAllActions];
//    }];
//    
//    [self removeAllChildren];
    for (SKNode *child in self.children) {
        [child removeFromParent];
    }
    [self removeFromParent];
   [_backgroundAudioPlayer stop];
    gAdBannerView=nil;
}
//- (void)removeFromParent
//{
//    [self.aShapeNode removeFromParent];
//    self.aShapeNode = nil;
//    
//    [super removeFromParent];
//}
-(void)setAnimationEndDuck{
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *bearAnimatedAtlas;
    if(self.mapState==FOREST_MAP){
        bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"ZuluEND"];
    }else if(self.mapState==GHOST_MAP){
        bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"witcEND"];
    }else if(self.mapState==ICE_MAP){
        bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"SnowEND"];
    }
    int numImages = (int)bearAnimatedAtlas.textureNames.count;
    for (int i=1; i <= numImages; i++) {
        NSString *textureName;
        if(self.mapState==FOREST_MAP){
            if(i<10){
                textureName = [NSString stringWithFormat:@"Zulu000%d", i];
            }else{
                textureName = [NSString stringWithFormat:@"Zulu00%d", i];
            }
            
        }else if(self.mapState==GHOST_MAP){
            if(i<10){
                 textureName = [NSString stringWithFormat:@"witchEND000%d", i];
            }else{
                 textureName = [NSString stringWithFormat:@"witchEND00%d", i];
            }
           
        }else if(self.mapState==ICE_MAP){
            if(i<10){
            textureName = [NSString stringWithFormat:@"snowEND000%d", i];
            }else{
            textureName = [NSString stringWithFormat:@"snowEND00%d", i];
            }
        }
        SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    duckEndFrames = walkFrames;

}
-(void)setAnimationDuck{
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *bearAnimatedAtlas;
    if(self.mapState==FOREST_MAP){
           bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Zulu"];
    }else if(self.mapState==GHOST_MAP){
           bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"witch"];
    }else if(self.mapState==ICE_MAP){
           bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"snow"];
    }
 
    int numImages = (int)bearAnimatedAtlas.textureNames.count;
    for (int i=1; i <= numImages; i++) {
        NSString *textureName;
        if(self.mapState==FOREST_MAP){
            textureName = [NSString stringWithFormat:@"zulu%d", i];
        }else if(self.mapState==GHOST_MAP){
            textureName = [NSString stringWithFormat:@"witch%d", i];
        }else if(self.mapState==ICE_MAP){
            textureName = [NSString stringWithFormat:@"snow%d", i];
        }
        SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    duckWalkingFrames = walkFrames;
}
-(void)addReadyGameView{
    if(self.mapState==FOREST_MAP){
        spriteDuck = [SKSpriteNode spriteNodeWithImageNamed:@"zulu1"];
    }else if(self.mapState==GHOST_MAP){
        spriteDuck = [SKSpriteNode spriteNodeWithImageNamed:@"witch1"];
    }else if(self.mapState==ICE_MAP){
        spriteDuck = [SKSpriteNode spriteNodeWithImageNamed:@"snow1"];
    }
    spriteDuck.physicsBody.velocity = self.physicsBody.velocity;
    
    spriteDuck.size = CGSizeMake(35,35);
    spriteDuck.position = CGPointMake(self.frame.size.width/4,self.frame.size.height/2);
    spriteDuck.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    spriteDuck.physicsBody.categoryBitMask = duckCategory;
    spriteDuck.physicsBody.collisionBitMask = allTargetCategory;//|coinCategory;
    spriteDuck.physicsBody.contactTestBitMask = allTargetCategory;
    spriteDuck.physicsBody.dynamic = NO;
    
    [self setAnimationDuck];
    [self setAnimationEndDuck];
    [self walkingDuck];
    [self initalizingScrollingAirBackground];
    [self initalizingScrollingGroundBackground];
    [self addChild:spriteDuck];
    [self createSceneContents];
    [self addScoreLabel];
    [self startBackgroundMusic];
    [self addHeighScore];
    [self initGameOverViewAndAdmob];
    if(readyGameView==nil){
        readyGameView = [[ReadyGameView alloc]init];
        readyGameView.frame =  CGRectMake(0,0,self.size.width, self.size.height);
        SKView * skView = (SKView *)self.view;
        [skView addSubview:readyGameView];
        [skView bringSubviewToFront:readyGameView];
        [readyGameView.readyButton addTarget:self action:@selector(readyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        if(self.mapState==FOREST_MAP){
            readyGameView.readyImageView.image = [UIImage imageNamed:@"ready-s1.png"];
        }else if(self.mapState==GHOST_MAP){
            readyGameView.readyImageView.image = [UIImage imageNamed:@"ready-s2.png"];
        }else if(self.mapState==ICE_MAP){
            readyGameView.readyImageView.image = [UIImage imageNamed:@"ready-s3.png"];
        }
    }
}
-(void)readyButtonPressed{
    readyGameView.hidden = YES;
    spriteDuck.physicsBody.dynamic = YES;
    isGameStart = YES;
}
-(void)initGameOverViewAndAdmob{
    if(gameOverView==nil){
        gameOverView = [[GameOverView alloc]init];
        gameOverView.frame =  CGRectMake(0,0,self.size.width, self.size.height);
        SKView * skView = (SKView *)self.view;
        [skView addSubview:gameOverView];
        [skView bringSubviewToFront:gameOverView];
        [gameOverView.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [gameOverView.gamecenterButton addTarget:self action:@selector(showGameCenterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [gameOverView.shareButton addTarget:self action:@selector(shareFaceBookPressed:) forControlEvents:UIControlEventTouchUpInside];
        [gameOverView.selectMapButton addTarget:self action:@selector(SelectMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(gAdBannerView==nil){
    gAdBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake((self.size.width/2)-(GAD_SIZE_320x50.width/2), -GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    gAdBannerView.adUnitID = @"e4a2102fe20a4f66";
    gAdBannerView.hidden = YES;
    gAdBannerView.delegate = self;
    gAdBannerView.rootViewController = self.view.window.rootViewController;
    [gameOverView addSubview:gAdBannerView];
    }
    gameOverView.hidden = YES;
}
-(void)addGameOverView{
 gameOverView.hidden = NO;
    [self showTopBanner:gAdBannerView];
    gameOverView.scoreLabel.text = [NSString stringWithFormat:@"%i",score];
    [self sendScore:score];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(score>[[userDefaults valueForKey:HIGH_SCORE_KEY] intValue]){
        gameOverView.scoreNewImage.hidden=NO;
        [userDefaults setValue:[NSString stringWithFormat:@"%i",score] forKey:HIGH_SCORE_KEY];
        [userDefaults synchronize];
//        heighScoreLabel.hidden = YES;
    }else{
        gameOverView.scoreNewImage.hidden=YES;
    }
    if([userDefaults valueForKey:HIGH_SCORE_KEY]&&((NSString*)[userDefaults valueForKey:HIGH_SCORE_KEY]).length>0){
        gameOverView.highScoreLabel.text = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:HIGH_SCORE_KEY]];
    }else{
        gameOverView.highScoreLabel.text = [NSString stringWithFormat:@"0"];
    }
    
    gameOverView.hidden = NO;
    // [self.view bringSubviewToFront:gameOverView];
}

- (void)sendScore:(int)vScore{
    [self reportScore:vScore forLeaderboardID:@"CandyScore"];
}

- (void) reportScore: (int64_t) vScore forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = vScore;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)hideTopBanner:(UIView *)banner{
    if (![banner isHidden]) {
        [UIView beginAnimations:@"bannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = YES;
    }
}

- (void)showTopBanner:(UIView *)banner{
    if ([banner isHidden]) {
        [UIView beginAnimations:@"bannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = NO;
    }
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self hideTopBanner:gAdBannerView];
    [self showTopBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    GADRequest *request =[GADRequest request];
//    request.testing = YES;
//request.testDevices = @[ @"14503a83b94f3dd470c7429075deabc6" ];
//    [gAdBannerView loadRequest:request];
    [self hideTopBanner:iAdBannerView];
    [self showTopBanner:gAdBannerView];
}

- (void) adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}

- (void) adViewDidReceiveAd:(GADBannerView *)banner{
    if ([iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
    [self performSelector:@selector(addGameOverView) withObject:nil afterDelay:1];
    
}

-(void)playButtonPressed:(id)sender{
    gameOverView.hidden = YES;
    //    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    MyScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
    scene.mapState = self.mapState;
    gAdBannerView.delegate = scene;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene ];

}

-(void)initalizingScrollingGroundBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg;
        if(self.mapState==FOREST_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"street"];
        }else if(self.mapState==GHOST_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"street_2"];
        }else if(self.mapState==ICE_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"street_3"];
        }
        
        bg.size = CGSizeMake(self.size.width*2, 90);
        bg.position = CGPointMake(i * self.size.width,0);
        [bg setScale:0.5];
        bg.anchorPoint = CGPointZero;
        bg.name = @"groundBg";
        bg.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bg.size];
        bg.physicsBody.categoryBitMask = allTargetCategory;
        bg.physicsBody.dynamic = NO;
        [self addChild:bg];
    }
}
-(void)SelectMapButtonPressed:(id)sender{
    gameOverView.hidden = YES;
    homeScene = [HomeScene sceneWithSize:self.view.bounds.size];
    homeScene.delegate = self;
    homeScene.scaleMode = SKSceneScaleModeAspectFill;
     gAdBannerView.delegate = homeScene.delegate;
    // Present the scene.
    [self.view presentScene:homeScene];
//
//    ViewController* viewController = [[ViewController alloc]init];

//    ChooseWorldScene * scene = [ChooseWorldScene sceneWithSize:self.view.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
//    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    [self.view presentScene:scene];
//    [self hideTopBanner:gAdBannerView];
//    [self hideTopBanner:iAdBannerView];
}
-(void)initalizingScrollingAirBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg;
        if(self.mapState==FOREST_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
            bg.size = CGSizeMake(956, 241);
            
            bg.position = CGPointMake(i * 956,self.size.height-241);
        }else if(self.mapState==GHOST_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky_2"];
            bg.size = CGSizeMake(956, 320);
            
            bg.position = CGPointMake(i * 956,self.size.height-320);
        }else if(self.mapState==ICE_MAP){
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky_3"];
            bg.size = CGSizeMake(956, 320);
            
            bg.position = CGPointMake(i * 956,self.size.height-320);
        }
        
        
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
}
- (void)startBackgroundMusic
{
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background-music.mp3" ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    // this will play the music infinitely
    _backgroundAudioPlayer.numberOfLoops = -1;
    //    [_backgroundAudioPlayer setVolume:1.0];
    [_backgroundAudioPlayer play];
}
- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    [self enumerateChildNodesWithName:@"groundBg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_GROUND_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
}
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
- (void) createSceneContents
{
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = airFlorCategory;
    
    self.name = @"bgAir";
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"velocity = %f",spriteDuck.physicsBody.velocity.dy);
    if(isGameOver)return;
    [self playSoundDuckTap];
    if(spriteDuck.position.y>self.size.height-spriteDuck.size.height/2){
        spriteDuck.physicsBody.velocity = CGVectorMake(0,0);
    }else{
        spriteDuck.physicsBody.velocity = CGVectorMake(0,300);
    }
}
-(void)addHeighScore{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults valueForKey:HIGH_SCORE_KEY]&&((NSString*)[userDefaults valueForKey:HIGH_SCORE_KEY]).length>0){
        
        SKSpriteNode *coinSprite;
        coinSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"candy"]];
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if (screenHeight < 500) {
            coinSprite.position = CGPointMake(400,self.size.height-30);
        }else{
            coinSprite.position = CGPointMake(470,self.size.height-30);
        }
        coinSprite.zPosition = 4;
        [self addChild:coinSprite];
        
        heighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        heighScoreLabel.fontName = @"Skranji";
        heighScoreLabel.text = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:HIGH_SCORE_KEY]];
        heighScoreLabel.fontSize = 28;
        heighScoreLabel.fontColor = [SKColor blackColor];
        heighScoreLabel.zPosition = 4;
        heighScoreLabel.position = CGPointMake(coinSprite.size.width+coinSprite.position.x,self.frame.size.height-41);
        
        dropShadowHeighScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        dropShadowHeighScore.fontName = @"Skranji";
        dropShadowHeighScore.fontSize = 28;
        dropShadowHeighScore.fontColor = [SKColor whiteColor];
        dropShadowHeighScore.text = heighScoreLabel.text;
        dropShadowHeighScore.zPosition = heighScoreLabel.zPosition - 1;
        dropShadowHeighScore.position = CGPointMake(dropShadowHeighScore.position.x + 1, dropShadowHeighScore.position.y + 1);
        
        [heighScoreLabel addChild:dropShadowHeighScore];
        
        [self addChild:heighScoreLabel];
    }
}
-(void)addScoreLabel{
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"0";
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.fontName = @"Skranji";
    scoreLabel.fontSize = 38;
    scoreLabel.zPosition = 4;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight < 500) {
        scoreLabel.position = CGPointMake(self.size.width-245,
                                          self.frame.size.height-45);
    }else{
        scoreLabel.position = CGPointMake(self.size.width-285,
                                      self.frame.size.height-45);
    }
    
    dropShadowScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    dropShadowScore.fontName = @"Skranji";
    dropShadowScore.fontSize = 38;
    dropShadowScore.fontColor = [SKColor whiteColor];
    dropShadowScore.text = scoreLabel.text;
    dropShadowScore.zPosition = scoreLabel.zPosition - 1;
    dropShadowScore.position = CGPointMake(dropShadowScore.position.x + 1, dropShadowScore.position.y + 1);
    
    [scoreLabel addChild:dropShadowScore];
    
    //    [gameOverLabel setScale:0.1];
    [self addChild:scoreLabel];
    //    [gameOverLabel runAction:[SKAction scaleTo:1.0 duration:0.5]];
}
-(void)playSoundKeepCoin{
    [self runAction:[SKAction playSoundFileNamed:@"pickup-candy.mp3" waitForCompletion:NO]];
}
-(void)playSoundDuckTap{
    [self runAction:[SKAction playSoundFileNamed:@"duck-tap.mp3" waitForCompletion:NO]];
}
-(void)playSoundDuckCrash{
    [self runAction:[SKAction playSoundFileNamed:@"duck-cash.mp3" waitForCompletion:NO]];
}
-(void)addCoin{
    //initalizing spaceship node
    SKSpriteNode *coinSprite;
    coinSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"candy"]];
    //Adding SpriteKit physicsBody for collision detection
    coinSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coinSprite.size.width/2];
    coinSprite.physicsBody.categoryBitMask = coinCategory;
    coinSprite.physicsBody.dynamic = NO;
    coinSprite.physicsBody.contactTestBitMask = duckCategory;
    coinSprite.physicsBody.collisionBitMask = duckCategory;
    //    coinSprite.physicsBody.usesPreciseCollisionDetection = YES;
    coinSprite.name = @"coin";
    //selecting random y position for missile
    coinSprite.position = CGPointMake(self.frame.size.width + 160,self.size.height/2+20);
    
    [self addChild:coinSprite];
}
-(void)addCoinWithPosition:(CGPoint)point{
    //initalizing spaceship node
    SKSpriteNode *coinSprite;
    coinSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"candy"]];
    //Adding SpriteKit physicsBody for collision detection
    coinSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coinSprite.size.width/2];
    coinSprite.physicsBody.categoryBitMask = coinCategory;
    coinSprite.physicsBody.dynamic = NO;
    coinSprite.physicsBody.contactTestBitMask = duckCategory;
    coinSprite.physicsBody.collisionBitMask = duckCategory;
    //    coinSprite.physicsBody.usesPreciseCollisionDetection = YES;
    coinSprite.name = @"coin";
    //selecting random y position for missile
    coinSprite.position = CGPointMake(point.x,point.y);
    
    [self addChild:coinSprite];
}
-(void)addItemWithPosition:(CGPoint)point{
    //initalizing spaceship node
    SKSpriteNode *coinSprite;
    coinSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"dood-candy.png"]];
    //Adding SpriteKit physicsBody for collision detection
    coinSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coinSprite.size.width/2];
    coinSprite.physicsBody.categoryBitMask = itemCategory;
    coinSprite.physicsBody.dynamic = NO;
    coinSprite.physicsBody.contactTestBitMask = duckCategory;
    coinSprite.physicsBody.collisionBitMask = duckCategory;
    //    coinSprite.physicsBody.usesPreciseCollisionDetection = YES;
    coinSprite.name = @"item";
    //selecting random y position for missile
    coinSprite.position = CGPointMake(point.x,point.y);
    
    [self addChild:coinSprite];
}
-(void)addBlock
{
    int blockStlye = 1+ arc4random() % 10;
    
    //initalizing spaceship node
    SKSpriteNode *upBlock;
    if(self.mapState==FOREST_MAP){
        upBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-up",blockStlye]];
    }else if(self.mapState==GHOST_MAP){
        upBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-up_2",blockStlye]];
    }else if(self.mapState==ICE_MAP){
        upBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-up_3",blockStlye]];
    }
    
    //Adding SpriteKit physicsBody for collision detection
    upBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:upBlock.size];
    upBlock.physicsBody.categoryBitMask = allTargetCategory;
    upBlock.physicsBody.dynamic = NO;
    upBlock.physicsBody.contactTestBitMask = duckCategory;
    upBlock.physicsBody.collisionBitMask = duckCategory;
    upBlock.physicsBody.usesPreciseCollisionDetection = YES;
    upBlock.name = @"block";
    //selecting random y position for missile
    upBlock.position = CGPointMake(self.frame.size.width + 40,self.size.height-upBlock.size.height/2);
    
    [self addChild:upBlock];
    
    //initalizing spaceship node
    SKSpriteNode *downBlock;
    if(self.mapState==FOREST_MAP){
        downBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-down",blockStlye]];
        downBlock.position = CGPointMake(self.frame.size.width + 40,35+downBlock.size.height/2);
    }else if(self.mapState==GHOST_MAP){
        downBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-down_2",blockStlye]];
        downBlock.position = CGPointMake(self.frame.size.width + 40,35+downBlock.size.height/2);
    }else if(self.mapState==ICE_MAP){
        downBlock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"style%d-down_3",blockStlye]];
        downBlock.position = CGPointMake(self.frame.size.width + 40,35+downBlock.size.height/2);
    }
    
    //Adding SpriteKit physicsBody for collision detection
    downBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:downBlock.size];
    downBlock.physicsBody.categoryBitMask = allTargetCategory;
    downBlock.physicsBody.dynamic = NO;
    downBlock.physicsBody.contactTestBitMask = duckCategory;
    downBlock.physicsBody.collisionBitMask = duckCategory;
    downBlock.physicsBody.usesPreciseCollisionDetection = YES;
    downBlock.name = @"block";
    //selecting random y position for missile
    
    
    [self addChild:downBlock];
    //    if(!isTestDebug){
    //        [self drawPhysicsBodies];
    //        isTestDebug = YES;
    //    }
    //addCoinWithPosition
    if(countRoundCoin%ITEM_RANG!=0){
        [self addCoinWithPosition:CGPointMake(downBlock.position.x,(downBlock.position.y+downBlock.size.height))];
        countRoundCoin+=1;
    }else{
        [self addItemWithPosition:CGPointMake(downBlock.position.x,(downBlock.position.y+downBlock.size.height))];
        countRoundCoin+=1;
    }
}
- (void)moveObstacle
{
    NSArray *nodes = self.children;//1
    
    for(SKNode * node in nodes){
        if ([node.name  isEqual: @"block"]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            CGPoint obVelocity = CGPointMake(-OBJECT_VELOCITY, 0);
            CGPoint amtToMove = CGPointMultiplyScalar(obVelocity,_dt);
            ob.position = CGPointAdd(ob.position, amtToMove);
            if(ob.position.x < -100)
            {
                [ob removeFromParent];
            }
        }else if ([node.name  isEqual: @"coin"]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            CGPoint obVelocity = CGPointMake(-OBJECT_VELOCITY, 0);
            CGPoint amtToMove = CGPointMultiplyScalar(obVelocity,_dt);
            ob.position = CGPointAdd(ob.position, amtToMove);
            if(ob.position.x < -100)
            {
                [ob removeFromParent];
            }
        }else if ([node.name  isEqual: @"item"]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            CGPoint obVelocity = CGPointMake(-OBJECT_VELOCITY, 0);
            CGPoint amtToMove = CGPointMultiplyScalar(obVelocity,_dt);
            ob.position = CGPointAdd(ob.position, amtToMove);
            if(ob.position.x < -100)
            {
                [ob removeFromParent];
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(isGameOver)return;
    if (_lastUpdateTime)
        
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;

    [self moveBg];
    if(!isGameStart)return;
    //move object & bg
    
    if( currentTime - _lastMissileAdded > 0.5)
    {
        _lastMissileAdded = currentTime + 1;
        [self addBlock];
    }
    if( currentTime - _lastCoinAdded > 0.5)
    {
        _lastCoinAdded = currentTime + 1;
        [self addCoin];
    }
    
    
    [self moveObstacle];
    
    if(!isGameOver){
        if(spriteDuck.physicsBody.velocity.dy>0){
            SKAction *moveNodeUp = [SKAction rotateToAngle:M_PI/4 duration:0.2];
            [spriteDuck runAction: moveNodeUp];
            
//            spriteDuck.zRotation = M_PI/4;
        }else{
            SKAction *moveNodeUp = [SKAction rotateToAngle:-M_PI/4 duration:0.2];
            [spriteDuck runAction: moveNodeUp];
            
//            spriteDuck.zRotation = -M_PI/4;
        }
    }
    //draw all physicsBodies in the scene
    
}
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if(isGameOver)return;
    if(!isGameStart)return;
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & duckCategory) != 0 &&
        (secondBody.categoryBitMask & allTargetCategory) != 0)
    {
        NSLog(@"begin crash");
        isGameOver = YES;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [self endingDuck];
        [self playSoundDuckCrash];
        [self showFlatScreen];
        if([self hasConnectivity]){
            GADRequest *request =[GADRequest request];
            [gAdBannerView loadRequest:request];
        }else{
             [self performSelector:@selector(addGameOverView) withObject:nil afterDelay:1];
        }
        //        [spriteDuck removeFromParent];
        //        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        //        [self.view presentScene:gameOverScene transition: reveal];
        //        [ship removeFromParent];
        //        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        //        [self.view presentScene:gameOverScene transition: reveal];
        
    }else if ((firstBody.categoryBitMask & duckCategory) != 0 &&
              (secondBody.categoryBitMask & coinCategory) != 0)
    {
        SKNode *contactNode = secondBody.node;
        [contactNode removeFromParent];
        [self playSoundKeepCoin];
        NSLog(@"coin crash");
        score+=1;
        [scoreLabel setText:[NSString stringWithFormat:@"%d",score]];
        [dropShadowScore setText:[NSString stringWithFormat:@"%d",score]];
        SKAction *zoomIn = [SKAction scaleTo:2.0 duration:0.25];
        SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.25];
        SKAction *sequence = [SKAction sequence:@[zoomIn, zoomOut]];
        [scoreLabel runAction: sequence];
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        if(score>[[userDefaults valueForKey:HIGH_SCORE_KEY] intValue]){
//            heighScoreLabel.hidden = YES;
            heighScoreLabel.text = [NSString stringWithFormat:@"%i",score];
            dropShadowHeighScore.text = [NSString stringWithFormat:@"%i",score];
        }
    }else if ((firstBody.categoryBitMask & duckCategory) != 0 &&
              (secondBody.categoryBitMask & itemCategory) != 0)
    {
        SKNode *contactNode = secondBody.node;
        [contactNode removeFromParent];
        [self playSoundKeepCoin];
        [self animationCointoDuck];
        NSLog(@"item crash");
        
    }
}
-(void)animationCointoDuck{
    NSArray *nodes = self.children;//1
    
    for(SKNode * node in nodes){
        if ([node.name  isEqual: @"coin"]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            ob.physicsBody = nil;
            [ob runAction:[SKAction moveTo:spriteDuck.position duration:0.5f]
                 completion:^{
                     [ob removeFromParent];
                     [self playSoundKeepCoin];
                     NSLog(@"coin crash");
                     score+=1;
                     [scoreLabel setText:[NSString stringWithFormat:@"%d",score]];
                     [dropShadowScore setText:[NSString stringWithFormat:@"%d",score]];
                     SKAction *zoomIn = [SKAction scaleTo:2.0 duration:0.25];
                     SKAction *zoomOut = [SKAction scaleTo:1.0 duration:0.25];
                     SKAction *sequence = [SKAction sequence:@[zoomIn, zoomOut]];
                     [scoreLabel runAction: sequence];
                     
                     NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                     if(score>[[userDefaults valueForKey:HIGH_SCORE_KEY] intValue]){
//                         heighScoreLabel.hidden = YES;
                     }


                 }];
        }
        
    }
}
-(void)showFlatScreen{
    if(!flatView){
        flatView = [[UIView alloc]init];
        flatView.backgroundColor = [UIColor whiteColor];
        flatView.frame =  CGRectMake(0,0,self.size.width, self.size.height);
        SKView * skView = (SKView *)self.view;
        flatView.alpha = 0;
        [skView addSubview:flatView];
        [skView bringSubviewToFront:flatView];
    }
    flatView.hidden=NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         flatView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              flatView.alpha = 0;
                                          }
                                          completion:^(BOOL finished){
                                              flatView.hidden = YES;
                                          }];
                     }];
}
- (void)showGameCenterPressed:(id)sender{
//    [self.delegate showGameCenter:sender];
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //        gameCenterController.leaderboardIdentifier = @"com.piyaphat.TestGameCenter.TestGameCenterBike";
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController: gameCenterController animated: YES completion:nil];
        
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareFaceBookPressed:(id)sender{
//    [self.delegate shareFacebook:sender];
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData*theImageData=UIImageJPEGRepresentation(theImage, 1.0 );
    //    [theImageData writeToFile:@"example.jpeg" atomically:YES];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController addImage:[UIImage imageWithData:theImageData]];
        [slComposeViewController addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/flappycandyduck-adventure/id887939637?ls=1&mt=8"]];
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController: slComposeViewController animated: YES completion:nil];
    }

}

- (void)showGameCenter:(id)sender
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //        gameCenterController.leaderboardIdentifier = @"com.piyaphat.TestGameCenter.TestGameCenterBike";
        
        [homeScene.view.window.rootViewController presentViewController:gameCenterController animated: YES completion:nil];
        
    }
    //    [self showLeaderboard:@"com.piyaphat.TestGameCenter.TestGameCenterBike"];
    
    
}

-(void)openAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/flappycandyduck-adventure/id887939637?ls=1&mt=8"]];
}
-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

@end
