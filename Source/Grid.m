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

static const int TILE_SIZE   = 50;
static const int GRID_WIDTH  = 320;
static const int GRID_HEIGHT = 450;

-(void)didLoadFromCCB
{
    _rows    = GRID_HEIGHT / TILE_SIZE;
    _columns = GRID_WIDTH  / TILE_SIZE;
    _offsetX = 10;
    _offsetY = 0;
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
            
        }
    }
}

@end
