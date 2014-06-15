//
//  ViewController.m
//  CandyDuck
//
//  Created by Amornthep on 2/8/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "ChooseWorldScene.h"
#import "HomeScene.h"
@implementation ViewController

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        NSLog(@"%f,%f",skView.bounds.size.width,skView.bounds.size.height);
        // Create and configure the scene.
//        MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
//        scene.delegate = self;
        
        HomeScene * scene = [HomeScene sceneWithSize:skView.bounds.size];
        scene.delegate = self;
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
    GKLocalPlayer * __weak localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil)
        {
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
        else if (localPlayer.isAuthenticated)
        {
            NSLog(@"Player authenticated");
            
        }
        else
        {
            NSLog(@"Player not authenticated");

        }
        //        NSLog(@"Error: %@",error);
        
    };
}

- (void)mySceneDelegate:(SKScene*)view{
    ((MyScene*)view).delegate = self;
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showGameCenter:(id)sender
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //        gameCenterController.leaderboardIdentifier = @"com.piyaphat.TestGameCenter.TestGameCenterBike";
        
        [self presentViewController:gameCenterController animated: YES completion:nil];
        
    }
    //    [self showLeaderboard:@"com.piyaphat.TestGameCenter.TestGameCenterBike"];
    
    
}

- (void)shareFacebook:(id)sender
{
//    CGSize sizeImage = CGSizeMake(324, 217);
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
        [self presentViewController:slComposeViewController animated: YES completion:nil];
    }
}

- (void)sendScore:(int)score{
    [self reportScore:score forLeaderboardID:@"CandyScore"];
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)openAppStore{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/flappycandyduck-adventure/id887939637?ls=1&mt=8"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
