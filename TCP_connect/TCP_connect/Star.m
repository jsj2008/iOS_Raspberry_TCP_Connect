//
//  Star.m
//  TCP_connect
//
//  Created by roikawa on 13/03/30.
//
//

#import "Star.h"
#import "GameScene.h"

@implementation Star

+(id)star{
//    NSLog(@"Star called");
    
    return [[[self alloc] initStar] autorelease];
}

-(id) initStar
{
	if ((self = [super initWithFile:@"star_70.png"]))
	{
        //速度初期化
        velocity_ = CGPointMake(-4.0, 0);
        [self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
    //	NSLog(@"★★★dealloc");
	// don't forget to call "super dealloc"
	[super dealloc];
}


-(void) update:(ccTime)delta
{
    //移動処理
    CGPoint pos = self.position;
    self.position = ccp(pos.x + velocity_.x, pos.y + velocity_.y);
    
    //左画面端に来たらオブジェクト消去
    if (self.position.x <= 0) {
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)onEnter{
    [super onEnter];
}

-(void)onExit{
    [super onExit];
}

@end
