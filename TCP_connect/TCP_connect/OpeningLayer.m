//
//  OpeningLayer.m
//  TCP_connect
//
//  Created by roikawa on 13/03/28.
//
//

#import "OpeningLayer.h"
#import "ParallaxBackground.h"
#import "SettingLayer.h"

@implementation OpeningLayer

// Helper class method that creates a Scene with the GameScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OpeningLayer *layer = [OpeningLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super's" return value
    if( (self=[super init]) )
    {
        //touch enable
        self.isTouchEnabled = YES;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //back
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:background z:1];
		
        //スクロールレイヤー
        ParallaxBackground* scroll = [ParallaxBackground node];
        [self addChild:scroll z:2];
        
        //タイトル
        CCSprite* title_1 = [CCSprite spriteWithFile:@"title.png"];
        title_1.position = ccp(screenSize.width*0.5, screenSize.height*0.75);
        [self addChild:title_1 z:3];
        
        CCSprite* title_2 = [CCSprite spriteWithFile:@"touch.png"];
        title_2.position = ccp(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:title_2 z:3];
        
        //ボタン生成
        CCMenuItemImage* startMenuItem_ = [CCMenuItemImage
                          itemFromNormalImage:@"start.png" selectedImage:@"start_sel.png"
                          target:self selector:@selector(startButtonTapped:)];
        startMenuItem_.position = ccp(screenSize.width*0.5, screenSize.height*0.25);
        CCMenu *menu = [CCMenu menuWithItems:startMenuItem_, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:3];
        
    }
    return self;
}

//ゲームスタート
- (void)startButtonTapped:(id)sender {
    //次の画面に遷移
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[SettingLayer scene] withColor:ccWHITE]];
}

//
-(void) onEnter
{
	[super onEnter];
    
//    // ask director for the window size
//	CGSize size = [[CCDirector sharedDirector] winSize];
//    
//    CCSprite* opImage = [CCSprite spriteWithFile:@"background.png"];
//    opImage.position = ccp(size.width/2, size.height/2);
    
//    [self addChild:opImage];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
