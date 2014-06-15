//
//  HomeScene.m
//  CandyDuck
//
//  Created by Amornthep on 3/9/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "HomeScene.h"
#import "ChooseWorldScene.h"
static const float BG_VELOCITY = 100.0;
static const float BG_GROUND_VELOCITY = 160.0;
//static const float OBJECT_VELOCITY = 160.0;
@implementation HomeScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
    
         [self performSelector:@selector(addReadyGameView) withObject:nil afterDelay:0.5];
    }
    return self;
}

-(void)addReadyGameView{
    [self initalizingScrollingAirBackground];
    [self initalizingScrollingGroundBackground];
    [self addUpRoof];
    [self candyDuckImage];
    [self addPlayButton];
    [self addStoryBoardButton];
    [self addRateButton];
    self.backgroundColor = [SKColor whiteColor];
}


-(void)initalizingScrollingAirBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg;
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
        bg.size = CGSizeMake(956, 241);
        bg.position = CGPointMake(i * 956,self.size.height-241);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
}
-(void)addStoryBoardButton{
    SKSpriteNode *buttonPlay;
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"Leaderboard-icon-Home.png"];
    buttonPlay.position = CGPointMake((buttonPlay.size.width/2)+10,(self.size.height/2)+20);
    buttonPlay.name = @"StoryBoardButton";
    [self addChild:buttonPlay];
}
-(void)addRateButton{
    SKSpriteNode *buttonPlay;
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"RATE-icon.png"];
    buttonPlay.position = CGPointMake((buttonPlay.size.width/2)+10,(self.size.height/2)-40);
    buttonPlay.name = @"RateButton";
    [self addChild:buttonPlay];
}
-(void)addPlayButton{
    SKSpriteNode *buttonPlay;
    buttonPlay = [SKSpriteNode spriteNodeWithImageNamed:@"Play-icon-Home.png"];
    buttonPlay.position = CGPointMake(self.size.width-(buttonPlay.size.width/2)-10,self.size.height/2);
    buttonPlay.name = @"buttonPlay";
    [self addChild:buttonPlay];
}
-(void)candyDuckImage{
    SKSpriteNode *bg;
    bg = [SKSpriteNode spriteNodeWithImageNamed:@"candyduck-icon.png"];
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    float widthImg = 0;
    if (screenHeight < 500) {
        widthImg = self.size.width/2-15;
    }else{
        widthImg = self.size.width/2;
    }
    bg.position = CGPointMake(widthImg,self.size.height/2);
    SKAction *moveDown = [SKAction moveTo:CGPointMake(widthImg,(self.size.height/2)-15) duration:0.8];
    SKAction *moveUp = [SKAction moveTo:CGPointMake(widthImg,(self.size.height/2)+20) duration:0.8];
    SKAction *sequence = [SKAction sequence:@[moveDown,moveUp]];
    SKAction *forever = [SKAction repeatActionForever:sequence];
    [self addChild:bg];
    [bg runAction: forever];
}
-(void)addUpRoof{
    SKSpriteNode *bg;
    bg = [SKSpriteNode spriteNodeWithImageNamed:@"tree-top.png"];
    bg.position = CGPointMake(0,self.size.height-bg.size.height);
    bg.anchorPoint = CGPointZero;
    [self addChild:bg];
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
-(void)update:(CFTimeInterval)currentTime {
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
}
-(void)initalizingScrollingGroundBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg;
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"street"];

        bg.size = CGSizeMake(self.size.width*2, 90);
        bg.position = CGPointMake(i * self.size.width,0);
        [bg setScale:0.5];
        bg.anchorPoint = CGPointZero;
        bg.name = @"groundBg";
        bg.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bg.size];
        bg.physicsBody.dynamic = NO;
        [self addChild:bg];
    }
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"buttonPlay"]) {
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        ChooseWorldScene * scene = [ChooseWorldScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }else if ([node.name isEqualToString:@"StoryBoardButton"]) {
        [self.delegate showGameCenter:nil];
    }else if ([node.name isEqualToString:@"RateButton"]) {
        [self.delegate openAppStore];
    }

}



@end
