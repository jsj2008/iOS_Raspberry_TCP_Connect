//
//  OpeningLayer.h
//  TCP_connect
//
//  Created by roikawa on 13/03/28.
//
//

#import "cocos2d.h"
#import "sys/socket.h"
#import "netinet/in.h"
#import "netinet6/in6.h"
#import "arpa/inet.h"
#import "ifaddrs.h"
#import "netdb.h"

@interface OpeningLayer : CCLayer
{
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;

@end
