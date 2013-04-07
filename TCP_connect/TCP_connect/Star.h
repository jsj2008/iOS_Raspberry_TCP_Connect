//
//  Star.h
//  TCP_connect
//
//  Created by roikawa on 13/03/30.
//
//

#import "Foundation/Foundation.h"
#import "cocos2d.h"

@interface Star : CCSprite {
    CGPoint velocity_;  //速度
}

+(id) star;
@property CGPoint velocity;

@end
