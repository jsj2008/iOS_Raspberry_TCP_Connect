//
//  GameScene.m
//  TCP_connect
//
//  Created by roikawa on 13/03/20.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "ParallaxBackground.h"
#import "Star.h"

#pragma mark - GameScene

// GameScene implementation
@implementation GameScene

@synthesize touchArea=touchArea_;
@synthesize frameCount=frameCount_;

// Helper class method that creates a Scene with the GameScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        //タッチイベントon
        self.isTouchEnabled = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //GameSettings
        gameSettings_ = [GameSettings sharedSettings];
        
        //back
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:background z:0];
		
        //スクロールレイヤー（今はオフ）
//		ParallaxBackground* scroll = [ParallaxBackground node];
//		[self addChild:scroll z:2];
        
        //タッチ可能領域を取得
        Star* ssobj = [Star star];
        touchArea_ = [self getTouchArea:ssobj];
        
        //星の生成頻度初期化
        frameCount_ = 0;
        
        //星用batchlayer追加
        spriteBatch_ = [CCSpriteBatchNode batchNodeWithFile:@"star_70.png"];
        [self addChild:spriteBatch_ z:10 tag:77];
        
        //スレッド開始
        [self scheduleUpdate];
	}
	return self;
}

//星とタッチポイントの当たり判定
-(void)hitCheck:(CGPoint)position
{
    Star* ssobj = nil;
    bool hit = false;
    
    //当たり判定チェック
    CCARRAY_FOREACH(spriteBatch_.children, ssobj) {
        //当たり判定
        CGRect rect = CGRectMake(ssobj.position.x - (ssobj.boundingBox.size.width/2),
                                 ssobj.position.y -(ssobj.boundingBox.size.height/2),
                                 ssobj.boundingBox.size.width,
                                 ssobj.boundingBox.size.height);
        
        if( CGRectContainsPoint( rect , position ) ){
            [ssobj removeFromParentAndCleanup:YES];
            hit = true;
//            NSLog(@"star remove");
        }
    }
    
    //星の当たり判定チェック
    if (hit) {        
        [gameSettings_.queue addOperationWithBlock:^{
            //connect
            if([gameSettings_ connect_to_server]){
                [gameSettings_ send_command:@"star"];
            }
            [gameSettings_ close_socket];
        }];
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CCLOG(@"☆☆☆CClayer touch start");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPosition = [touch locationInView:touch.view];
    CGPoint position      = [[CCDirector sharedDirector] convertToGL:touchPosition];
//    CCLOG(@"CClayer move x[%f] y[%f]", position.x , position.y );
    
    [self hitCheck:position];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    CCLOG(@"CClayer touch start");
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPosition = [touch locationInView:touch.view];
    CGPoint position      = [[CCDirector sharedDirector] convertToGL:touchPosition];
    //    CCLOG(@"CClayer move x[%f] y[%f]", position.x , position.y );
    
    [self hitCheck:position];
}

-(void)update:(ccTime)delta
{
    frameCount_++;
    
    //フレームごとに星オブジェクト生成
    if(frameCount_>10)
    {        
        CCDirector *director_=[CCDirector sharedDirector];
        CGSize screenSize = [director_ winSize];
        
        //ランダムで星かハートを生成
        CCSprite* ssobj = [Star star];
        float objSizeHeight = [ssobj texture].contentSize.height;
        
        //ランダムでポジション設定
        float y_rand=0.0;
        NSNumber* touch_h = [NSNumber numberWithFloat:(touchArea_.height)];
        
        y_rand = rand()%[touch_h intValue] + objSizeHeight/2;
        ssobj.position = CGPointMake(screenSize.width, y_rand);
        
        [spriteBatch_ addChild:ssobj z:10 tag:77];
                
        //フレームカウント初期化
        frameCount_=0;
    }
}

//タッチ可能領域を取得する
-(CGSize)getTouchArea:(CCSprite*) obj
{
    CCDirector *director_=[CCDirector sharedDirector];
    CGSize screenSize = [director_ winSize];
    
    //描画するオブジェクトの幅分touchAreaを小さくする
    float objSizeWidth = [obj texture].contentSize.width;
    float objSizeHeight = [obj texture].contentSize.height;
    
    NSNumber* t_w = [NSNumber numberWithFloat:(screenSize.width - objSizeWidth)];
    NSNumber* t_h = [NSNumber numberWithFloat:(screenSize.height - objSizeHeight)];
    
    return CGSizeMake([t_w intValue], [t_h intValue]);
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

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
