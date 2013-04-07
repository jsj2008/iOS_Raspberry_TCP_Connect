//
//  GameScene.h
//  TCP_connect
//
//  Created by roikawa on 13/03/20.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameSettings.h"

// GameScene
@interface GameScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize touchArea_;  //タッチ可能領域
    int frameCount_;   //星の生成タイミングカウント
    CCSpriteBatchNode* spriteBatch_;
    
    GameSettings* gameSettings_;
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;
-(CGSize)getTouchArea:(CCSprite*) obj;

@property CGSize touchArea;
@property int frameCount;

@end
