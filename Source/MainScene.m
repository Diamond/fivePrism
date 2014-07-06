//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Grid.h"

@implementation MainScene {
    CCLabelTTF *_scoreLabel;
    Grid       *_grid;
}

-(void)didLoadFromCCB
{
    //[CCBReader load:@"Grid"];
}


-(void)redraw
{
    [_grid redraw];
}

@end
