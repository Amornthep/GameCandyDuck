//
//  ChooseWorldScene.m
//  CandyDuck
//
//  Created by Bike on 2/26/2557 BE.
//  Copyright (c) 2557 Amornthep. All rights reserved.
//

#import "ChooseWorldScene.h"
#import "MyScene.h"

@implementation ChooseWorldScene{
    int selectedWorld;
    int scene;
    MyScene* myScene;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        [self performSelector:@selector(addChooseWorldView) withObject:nil afterDelay:0.5];
    }
    return self;
}


-(void)addChooseWorldView{
    if(chooseWorldView==nil){
        chooseWorldView = [[ChooseWorldView alloc]init];
        chooseWorldView.frame =  CGRectMake(0,0,self.size.width, self.size.height);
        SKView * skView = (SKView *)self.view;
        [skView addSubview:chooseWorldView];
        [skView bringSubviewToFront:chooseWorldView];
        [chooseWorldView.select1Button addTarget:self action:@selector(selectButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [chooseWorldView.select2Button addTarget:self action:@selector(selectButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [chooseWorldView.preButton addTarget:self action:@selector(preButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [chooseWorldView.nextButton addTarget:self action:@selector(nextButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        selectedWorld = 1;
        scene = 1;
        [chooseWorldView.playButton addTarget:self action:@selector(addMyscene) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)selectButtonPress:(id)sender{
    if (((UIButton*)sender).tag == 1) {
        chooseWorldView.select1Button.selected = YES;
        chooseWorldView.select2Button.selected = NO;
        if (scene == 1) {
            selectedWorld = 1;
        }else if (scene == 2){
            selectedWorld = 3;
        }
        
    }else if (((UIButton*)sender).tag == 2) {
        chooseWorldView.select1Button.selected = NO;
        chooseWorldView.select2Button.selected = YES;
        selectedWorld = 2;
    }
}

-(void)preButtonPress:(id)sender{
    chooseWorldView.select2Button.hidden = NO;
    chooseWorldView.worldOne.image = [UIImage imageNamed:@"stat-1.png"];
    chooseWorldView.worldTwo.image = [UIImage imageNamed:@"stat-2.png"];
    scene = 1;
    if (selectedWorld == 1) {
        chooseWorldView.select1Button.selected = YES;
    }else{
        chooseWorldView.select1Button.selected = NO;
    }
}

-(void)nextButtonPress:(id)sender{
    chooseWorldView.select2Button.hidden = YES;
    chooseWorldView.worldOne.image = [UIImage imageNamed:@"stat-3.png"];
    chooseWorldView.worldTwo.image = [UIImage imageNamed:@"stat-4.png"];
    scene = 2;
    if (selectedWorld == 3) {
        chooseWorldView.select1Button.selected = YES;
    }else{
        chooseWorldView.select1Button.selected = NO;
    }
}

-(void)addMyscene{
    chooseWorldView.hidden = YES;
//    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    MyScene * scene2 = [MyScene sceneWithSize:self.view.bounds.size];
    scene2.mapState = selectedWorld;
    scene2.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene2];
    
}



@end
