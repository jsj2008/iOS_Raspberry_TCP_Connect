//
//  ParallaxBackground.h
//  TCP_connect
//
//  Created by roikawa on 13/03/20.
//
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface ParallaxBackground : CCNode
{
	CCSpriteBatchNode* spriteBatch;
	
	int numStripes;
	
	CCArray* speedFactors;
	float scrollSpeed;
	
	CGSize screenSize;
}

@end
