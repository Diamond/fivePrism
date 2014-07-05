//
//  Grid.m
//  FivePrism
//
//  Created by Brandon Richey on 7/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"

@implementation Grid {
    NSMutableArray *_gridArray;
    int            _rows;
    int            _columns;
    int            _offsetX;
    int            _offsetY;
}

static const int TILE_SIZE   = 40;
static const int GRID_WIDTH  = 320;
static const int GRID_HEIGHT = 440;

-(void)didLoadFromCCB
{
    _rows    = (GRID_HEIGHT / TILE_SIZE) - 1;
    _columns = GRID_WIDTH  / TILE_SIZE;
    _offsetX = 0;
    _offsetY = 50;

    [self initGrid];
    [self setupGrid];
    
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];

    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];

    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
}

-(void)swipeLeft
{
    CCLOG(@"left");
}

-(void)swipeRight
{
    CCLOG(@"right");
}

-(void)swipeDown
{
    CCLOG(@"down");
}

-(void)swipeUp
{
    CCLOG(@"up");
}

-(void)initGrid
{
    _gridArray = [NSMutableArray array];
    for (int y = 0; y < _rows; y++) {
        _gridArray[y] = [NSMutableArray array];
    }
}

-(void)setupGrid
{
    for (int y = 0; y < _rows; y++) {
        for (int x = 0; x < _columns; x++) {
            Tile *newTile = (Tile*)[CCBReader load:@"Tile"];
            [newTile build];
            int positionX = _offsetX + (x * TILE_SIZE);
            int positionY = _offsetY + (y * TILE_SIZE);
            newTile.position = ccp(positionX, positionY);
            _gridArray[y][x] = newTile;
            [self addChild:newTile];
        }
    }
}

@end
