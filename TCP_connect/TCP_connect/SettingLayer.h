//
//  SettingLayer.h
//  TCP_connect
//
//  Created by roikawa on 13/03/31.
//
//

#import "cocos2d.h"
#import "GameScene.h"
#import "GameSettings.h"

@interface SettingLayer : CCLayer<UITextFieldDelegate>
{
    CCSprite *background_;
    CCSprite *setting_;
    CCSprite *note_;
    CCSprite *error_;
    
    UITextField *tf_ip_;
    UITextField *tf_port_;
    UIButton *btn_check_;
    UIButton *btn_back_;
    UIView *enterView_;
    
    GameSettings* gameSettings_;
}

// returns a CCScene that contains the GameScene as the only child
+(CCScene *) scene;

@end
