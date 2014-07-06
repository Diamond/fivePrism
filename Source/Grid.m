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
    NSNull         *_nullTile;
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

    _nullTile = [NSNull null];

    [self initGrid];
    [self setupGrid];
    
    self.anchorPoint = ccp(0,1);
    self.position = ccp(0,120);
    
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
    [self moveLeft];
    [self setupGrid];
    [self debugGrid];
}

-(void)swipeRight
{
    CCLOG(@"swipe right");
    [self moveRight];
    [self setupGrid];
    [self debugGrid];
}

-(void)swipeDown
{
    CCLOG(@"swipe down");
    [self moveUp];
    [self debugGrid];
}

-(void)swipeUp
{
    CCLOG(@"swipe up");
    [self moveDown];
    [self debugGrid];
}

-(void)moveLeft
{
    for (int x = 1; x < _columns; x++) {
        for (int y = 0; y < _rows; y++) {
            if (_gridArray[y][x] == _nullTile) {
                continue;
            }
            Tile *origin = (Tile*)_gridArray[y][x];
            if (_gridArray[y][x-1] != _nullTile) {
                Tile *compare = (Tile*)_gridArray[y][x-1];
                if (origin.value != compare.value) continue;
            }
            int bestX = x;
            for (int deltaX = x; deltaX >= 0; deltaX--) {
                if (_gridArray[y][deltaX] == _nullTile) {
                    bestX = deltaX;
                    continue;
                }
                Tile *compare = (Tile*)_gridArray[y][deltaX];
                if (origin.value == compare.value) {
                    bestX = deltaX;
                    continue;
                } else {
                    break;
                }
            }
            int originalY = origin.position.y;
            CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.5f position:ccp((bestX) * TILE_SIZE, originalY)];
            [origin runAction:moveTo];
            _gridArray[y][bestX]    = origin;
            _gridArray[y][x]        = _nullTile;
        }
    }
}

-(void)moveRight
{
    for (int x = _columns-2; x >= 0; x--) {
        for (int y = 0; y < _rows; y++) {
            if (_gridArray[y][x] == _nullTile) {
                continue;
            }
            Tile *origin = (Tile*)_gridArray[y][x];
            if (_gridArray[y][x+1] != _nullTile) {
                Tile *compare = (Tile*)_gridArray[y][x+1];
                if (origin.value != compare.value) continue;
            }
            int bestX = x;
            for (int deltaX = x; deltaX <= _columns-1; deltaX++) {
                if (_gridArray[y][deltaX] == _nullTile) {
                    bestX = deltaX;
                    continue;
                }
                Tile *compare = (Tile*)_gridArray[y][deltaX];
                if (origin.value == compare.value) {
                    bestX = deltaX;
                    continue;
                } else {
                    break;
                }
            }
            int originalY = origin.position.y;
            CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.5f position:ccp((bestX) * TILE_SIZE, originalY)];
            [origin runAction:moveTo];
            _gridArray[y][bestX]    = origin;
            _gridArray[y][x]        = _nullTile;
        }
    }
}

-(void)moveUp
{
    for (int y = 1; y < _rows; y++) {
        for (int x = 0; x < _columns; x++) {
            if (_gridArray[y][x] == _nullTile) {
                continue;
            }
            Tile *origin = (Tile*)_gridArray[y][x];
            if (_gridArray[y-1][x] != _nullTile) {
                Tile *compare = (Tile*)_gridArray[y-1][x];
                if (origin.value != compare.value) continue;
            }
            int bestY = y;
            for (int deltaY = y; deltaY < 0; deltaY--) {
                if (_gridArray[deltaY][x] == _nullTile) {
                    bestY = deltaY;
                    continue;
                }
                Tile *compare = (Tile*)_gridArray[deltaY][x];
                if (origin.value == compare.value) {
                    bestY = deltaY;
                    continue;
                } else {
                    break;
                }
            }
            int originalX    = origin.position.x;
            int destinationY = (bestY * TILE_SIZE) + _offsetY;
            CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.5f position:ccp(originalX, destinationY)];
            [origin runAction:moveTo];
            _gridArray[bestY][x]    = origin;
            _gridArray[y][x]        = _nullTile;
        }
    }
}

-(void)moveDown
{
    for (int y = _rows-2; y >= 0; y--) {
        for (int x = 0; x < _columns; x++) {
            if (_gridArray[y][x] == _nullTile) {
                continue;
            }
            Tile *origin = (Tile*)_gridArray[y][x];
            if (_gridArray[y+1][x] != _nullTile) {
                Tile *compare = (Tile*)_gridArray[y+1][x];
                if (origin.value != compare.value) continue;
            }
            int bestY = y;
            for (int deltaY = y; deltaY < _rows; deltaY++) {
                if (_gridArray[deltaY][x] == _nullTile) {
                    bestY = deltaY;
                    continue;
                }
                Tile *compare = (Tile*)_gridArray[deltaY][x];
                if (origin.value == compare.value) {
                    bestY = deltaY;
                    continue;
                } else {
                    break;
                }
            }
            int originalX    = origin.position.x;
            int destinationY = (bestY * TILE_SIZE) + _offsetY;
            CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.5f position:ccp(originalX, destinationY)];
            [origin runAction:moveTo];
            _gridArray[bestY][x]    = origin;
            _gridArray[y][x]        = _nullTile;
        }
    }
}

-(void)initGrid
{
    _gridArray = [NSMutableArray array];
    for (int y = 0; y < _rows; y++) {
        _gridArray[y] = [NSMutableArray array];
        for (int x = 0; x < _columns; x++) {
            _gridArray[y][x] = _nullTile;
        }
    }
}

-(void)setupGrid
{
    for (int y = 0; y < _rows; y++) {
        for (int x = 0; x < _columns; x++) {
            if (_gridArray[y][x] != _nullTile) continue;
            
            Tile *newTile = (Tile*)[CCBReader load:@"Tile"];
            [newTile build];
            int positionX = _offsetX + (x * TILE_SIZE);
            int positionY = _offsetY + (y * TILE_SIZE);
            newTile.position = ccp(positionX, 0);
            _gridArray[y][x] = newTile;
            [self addChild:newTile];
            CCActionMoveTo *fallTo = [CCActionMoveTo actionWithDuration:0.5f position:ccp(positionX, positionY)];
            [newTile runAction:fallTo];
        }
    }
}

-(void)debugGrid
{
    NSString *data = @"";
    for (int y = 0; y < _rows; y++) {
        for (int x = 0; x < _columns; x++) {
            if (_gridArray[y][x] != _nullTile) {
                [data stringByAppendingFormat:@"%d",((Tile*)_gridArray[y][x]).value];
            }
        }
        CCLOG(@"%@",data);
        data = @"";
    }
}

@end
