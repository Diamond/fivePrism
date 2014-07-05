//
//  Tile.m
//  FivePrism
//
//  Created by Brandon Richey on 7/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tile.h"

static const int COLORS = 5;

@implementation Tile {
    CCNodeColor *_colorNode;
}

-(void)build {
    self.value = (arc4random() % COLORS);
    [self setupColor];
}

-(void)setupColor {
    switch (self.value) {
        case 0:
            // Blue
            _colorNode.color = [CCColor colorWithRed:0.0f green:[self color255:84.0f] blue:1.0f];
            break;
        case 1:
            // Pink
            _colorNode.color = [CCColor colorWithRed:[self color255:228.0f] green:0.0f blue:1.0f];
            break;
        case 2:
            // Lime
            _colorNode.color = [CCColor colorWithRed:0.0f green:1.0f blue:0.5f];
            break;
        case 3:
            // Red
            _colorNode.color = [CCColor colorWithRed:1.0f green:0.0f blue:0.0f];
            break;
        case 4:
        default:
            // Yellow
            _colorNode.color = [CCColor colorWithRed:1.0f green:[self color255:216.0f] blue:0.0f];
            break;
    }
}

-(float)color255:(float)colorValue
{
    return 255.0f / colorValue;
}

@end
