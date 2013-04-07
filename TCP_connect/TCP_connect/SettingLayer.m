//
//  SettingLayer.m
//  TCP_connect
//
//  Created by roikawa on 13/03/31.
//
//

#import "SettingLayer.h"
#import "OpeningLayer.h"

@implementation SettingLayer

// Helper class method that creates a Scene with the GameScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingLayer *layer = [SettingLayer node];
	
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
        
        //GameSettings
        gameSettings_ = [GameSettings sharedSettings];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //back
        background_ = [CCSprite spriteWithFile:@"background.png"];
        background_.position = ccp(screenSize.width*0.5,screenSize.height*0.5);
        [self addChild:background_ z:1];
        
        //setting
        setting_ = [CCSprite spriteWithFile:@"setting.png"];
        setting_.position = ccp(screenSize.width*0.25,screenSize.height*0.85);
        [self addChild:setting_ z:2];
        
        //note
        note_ = [CCSprite spriteWithFile:@"note.png"];
        note_.position = ccp(screenSize.width*0.5,screenSize.height*0.73);
        [self addChild:note_ z:2];
        
        //error(visible=false)
        error_ = [CCSprite spriteWithFile:@"connect_error.png"];
        error_.position = ccp(screenSize.width*0.5,screenSize.height*0.30);
        error_.visible=NO;
        [self addChild:error_ z:2];
        
        //画面生成
        CCDirector* director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
        
        enterView_ = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
        [[director_ view] addSubview:enterView_];
        
        //IP アドレス入力域
        tf_ip_ = [[[UITextField alloc] initWithFrame:CGRectMake(screenSize.width*0.5-150,
                                                            screenSize.height*0.35,
                                                            200,30)] autorelease];
        tf_ip_.delegate = self;
        tf_ip_.textAlignment = UITextAlignmentLeft;
        tf_ip_.borderStyle = UITextBorderStyleRoundedRect;
        tf_ip_.textColor = [UIColor blueColor];
        tf_ip_.placeholder = @"IP adress";
        tf_ip_.clearButtonMode = UITextFieldViewModeAlways;
        [enterView_ addSubview:tf_ip_];
        
        //port入力域
        tf_port_ = [[[UITextField alloc] initWithFrame:CGRectMake(screenSize.width*0.5+55,
                                                               screenSize.height*0.35,
                                                               100,30)] autorelease];
        tf_port_.delegate = self;
        tf_port_.textAlignment = UITextAlignmentLeft;
        tf_port_.borderStyle = UITextBorderStyleRoundedRect;
        tf_port_.textColor = [UIColor blueColor];
        tf_port_.placeholder = @"port";
        tf_port_.clearButtonMode = UITextFieldViewModeAlways;
        [enterView_ addSubview:tf_port_];
        
        tf_ip_.text = @"";
        tf_port_.text = @"";
        
        //ボタン生成
        btn_check_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn_check_.frame = CGRectMake(screenSize.width*0.5-150,
                                     screenSize.height*0.25+78,
                                     150,30);
        [btn_check_ setTitle:@"Start" forState:UIControlStateNormal]; //有効時
        
        btn_back_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn_back_.frame = CGRectMake(screenSize.width*0.5,
                                      screenSize.height*0.25+78,
                                      150,30);
        [btn_back_ setTitle:@"Back" forState:UIControlStateNormal]; //有効時
        
        // ボタンがタッチダウンされた時にenter_btn_checkメソッドを呼び出す
        [btn_check_ addTarget:self action:@selector(enter_btn_check:)forControlEvents:UIControlEventTouchDown];
        [btn_back_ addTarget:self action:@selector(enter_btn_back:)forControlEvents:UIControlEventTouchDown];
        
        [enterView_ addSubview:btn_check_];
        [enterView_ addSubview:btn_back_];
    }
    return self;
}

// enter_btn_checkメソッド
-(void)enter_btn_back:(UIButton*)button{
    //エラーメッセージ非表示
    error_.visible=NO;
    
    //UIView削除
    [enterView_ removeFromSuperview];
    
    //トップ画面に戻る
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[OpeningLayer scene] withColor:ccWHITE]];
}

// enter_btn_checkメソッド
-(void)enter_btn_check:(UIButton*)button{
    NSLog(@"☆☆☆enter_btn_check");
    
    NSString* check_ip = tf_ip_.text;
    int check_port = [tf_port_.text intValue];
    
    NSLog(@"%@",check_ip);
    NSLog(@"%d",check_port);
    
    if ([check_ip isEqual: [NSNull null]] || check_port == -1) {
        //エラーメッセージ表示
        error_.visible=YES;
        
        return;
    }
    
    //GameSettingsに情報を保存
    gameSettings_.ip_addr = check_ip;
    gameSettings_.port_host = check_port;
    
    //サーバーアクセスチェック
    if (gameSettings_.checkConnect) {//OKの場合
        //エラーメッセージ非表示
        error_.visible=NO;
        
        //次画面に遷移
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene] withColor:ccWHITE]];
        
        //UIView削除
        [enterView_ removeFromSuperview];
    }else{
        //GameSettings初期化
        gameSettings_.ip_addr = @"";
        gameSettings_.port_host = -1;
        
        //エラーメッセージ表示
        error_.visible=YES;
    }
}

// 呼ばれるfocusOffメソッド
//-(void)focusOff:(UITextField*)textfield{
//    // ここに何かの処理を記述する
//    // （引数の textfield には呼び出し元のUITextFieldオブジェクトが引き渡されてきます）
//    NSLog(@"☆☆☆text");
//}

// キーボードのReturnボタンがタップされたらキーボードを閉じるようにする
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [tf_ip_ resignFirstResponder];
    [tf_port_ resignFirstResponder];
    return YES;
}

//
-(void) onEnter
{
	[super onEnter];
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
