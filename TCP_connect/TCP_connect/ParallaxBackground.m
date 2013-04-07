//
//  ParallaxBackground.m
//  TCP_connect
//
//  Created by roikawa on 13/03/20.
//
//

#import "ParallaxBackground.h"

@implementation ParallaxBackground

-(id) init
{
	if ((self = [super init]))
	{
		// The screensize never changes during gameplay, so we can cache it in a member variable.
		screenSize = [[CCDirector sharedDirector] winSize];
		
        NSString* frameName = [NSString stringWithFormat:@"star_5.png"];
        
		// Create the background spritebatch
        spriteBatch = [CCSpriteBatchNode batchNodeWithFile:frameName];
        [self addChild:spriteBatch z:1];
		
		numStripes = 1;
        
        CCSprite* sprite = [CCSprite spriteWithFile:frameName];
        CGSize spriteImageSize = [sprite texture].contentSize;
        
        sprite.anchorPoint = CGPointMake(0, 0.5f);
        sprite.position = CGPointMake(0, screenSize.height / 2);
        [spriteBatch addChild:sprite z:0 tag:0];
        
        // Position the new sprite one screen width to the right
        CCSprite* sprite_flip = [CCSprite spriteWithFile:frameName];
        sprite_flip.anchorPoint = CGPointMake(0, 0.5f);
        sprite_flip.position = CGPointMake(spriteImageSize.width, screenSize.height / 2);
        
        // Flip the sprite so that it aligns perfectly with its neighbor
        sprite_flip.flipX = YES;
        
        // Add the sprite using the same tag offset by numStripes
        [spriteBatch addChild:sprite_flip z:0 tag:numStripes];
		
		// Initialize the array that contains the scroll factors for individual stripes.
		speedFactors = [[CCArray alloc] initWithCapacity:numStripes];
		[speedFactors addObject:[NSNumber numberWithFloat:1.0f]];
		NSAssert([speedFactors count] == numStripes, @"speedFactors count does not match numStripes!");
		
		scrollSpeed = 1.0f;
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) dealloc
{
	[speedFactors release];
	[super dealloc];
}

-(void) update:(ccTime)delta
{
	CCSprite* sprite;
	CCARRAY_FOREACH([spriteBatch children], sprite)
	{
		NSNumber* factor = [speedFactors objectAtIndex:sprite.zOrder];
		
		CGPoint pos = sprite.position;
		pos.x -= scrollSpeed * [factor floatValue];
        
        CGSize spriteImageSize = [sprite texture].contentSize;
		
		// Reposition stripes when they're out of bounds
		if (pos.x < -spriteImageSize.width)
		{
//            NSLog(@"reposition");
			pos.x += spriteImageSize.width * 2 - 1;
		}
		
		sprite.position = pos;
	}
}

@end
