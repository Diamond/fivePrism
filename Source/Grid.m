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
    
//    int counter = 0;
//    NSMutableArray *test = [NSMutableArray array];
//    for (int i = 0; i < 4; i++) {
//        test[i] = [NSMutableArray array];
//        for (int j = 0; j < 5; j++) {
//            test[i][j] = [NSString stringWithFormat:@"%d",counter++];
//        }
//    }
//    for (int i = 0; i < 4; i++) {
//        for (int j = 0; j < 5; j++) {
//            CCLOG(@"i:%d j:%d => %@",i,j,test[i][j]);
//        }
//    }
    
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
    CCLOG(@"swipe left");
    [self moveGrids:ccp(-1.0f, 0.0f)];
}

-(void)swipeRight
{
    CCLOG(@"swipe right");
    [self moveGrids:ccp(+1.0f, 0.0f)];
}

-(void)swipeDown
{
    CCLOG(@"swipe down");
    [self moveGrids:ccp(0.0f, +1.0f)];
}

-(void)swipeUp
{
    CCLOG(@"swipe up");
    [self moveGrids:ccp(0.0f, -1.0f)];
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

-(void)moveGrids:(CGPoint)direction
{
    for (int y = 0; y < _rows; y++) {
        for (int x = 0; x < _columns; x++) {
            CGPoint moveTo = [self findSpotToMoveTo:x fromY:y moveX:(int)direction.x moveY:(int)direction.y];
            Tile *origin = (Tile*)_gridArray[y][x];
            [self moveTile:origin toX:(int)moveTo.x toY:(int)moveTo.y];
        }
    }
}

-(void)moveTile:(Tile*)tile toX:(int)x toY:(int)y
{
    CGPoint destination = ccp(x*TILE_SIZE, y*TILE_SIZE);
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:destination];
    [tile runAction:moveTo];
}

-(CGPoint)findSpotToMoveTo:(int)fromX fromY:(int)fromY moveX:(int)moveX moveY:(int)moveY
{
    int moveByX = 0;
    int moveByY = 0;
    
    while ([self isValidForMove:fromX fromY:fromY toX:fromX+moveByX toY:fromY+moveByY]) {
        moveByX += moveX;
        moveByY += moveY;
    }
    
    return ccp(fromX+moveByX, fromY+moveByY);
}

-(BOOL)isValidForMove:(int)fromX fromY:(int)fromY toX:(int)toX toY:(int)toY
{
    if (![self isPointValid:fromX y:fromY] || ![self isPointValid:toX y:toY]) {
        return FALSE;
    }
    
    //CCLOG(@"fromX: %d fromY: %d toX: %d toY: %d", fromX, fromY, toX, toY);
    
    Tile *oldTile = (Tile*)_gridArray[fromY][fromX];
    Tile *newTile = (Tile*)_gridArray[toY][toX];
    
    if (oldTile.value == newTile.value) {
        return TRUE;
    }
    
    return FALSE;
}

-(BOOL)isPointValid:(int)x y:(int)y
{
    return x >= 0 && x < _columns && y >= 0 && y < _rows;
}

@end
