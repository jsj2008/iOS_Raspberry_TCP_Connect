//
//  IntroLayer.m
//  TCP_connect
//
//  Created by roikawa on 13/03/20.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "OpeningLayer.h"


#pragma mark - IntroLayer

// GameScene implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the GameScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

    
    // ask director for the window size    
    CCSprite* introImage = [CCSprite spriteWithFile:@"intro.png"];
    introImage.position = ccp(size.width/2, size.height/2);
    
    [self addChild:introImage];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer scene] withColor:ccWHITE]];
}
@end
