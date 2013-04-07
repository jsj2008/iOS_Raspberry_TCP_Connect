//
//  GameSettings.m
//  TCP_connect
//
//  Created by roikawa on 13/03/31.
//
//

#import "GameSettings.h"

@implementation GameSettings

@synthesize ip_addr=ip_addr_;
@synthesize port_host=port_host_;
@synthesize queue=queue_;

static GameSettings* g_gameSettings = nil;

+(GameSettings*) sharedSettings
{
    if (!g_gameSettings)
    {
        g_gameSettings = [[GameSettings alloc] init];
    }
    return g_gameSettings;
}

-(id)init{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super's" return value
    if( (self=[super init]) ) {
        
        ip_addr_ = @"";
        port_host_ = -1;
        
        // オペレーションキューを作成
        queue_ = [[NSOperationQueue alloc] init];
        [queue_ setMaxConcurrentOperationCount:1];
    }
    return self;
}

//tcp通信
- (int)connect_to_server
{
//    ip_addr_ = @"172.20.10.5";
//    port_host_ = 8081;
    NSLog(@"☆☆☆connect_to_server:%@,%d",ip_addr_,port_host_);
    
    struct hostent *servhost;
    struct sockaddr_in server;
    
    servhost = (struct hostent *)gethostbyname( [ip_addr_ UTF8String] );
    if (servhost == NULL) {
        return 0;
    }
    bzero((char *)&server, sizeof(server));
    server.sin_family = AF_INET;
    bcopy(servhost->h_addr, (char *)&server.sin_addr, servhost->h_length);
    server.sin_port = htons(port_host_);
    if ((sock_=socket(AF_INET, SOCK_STREAM, 0))<0) {
        return 0;
    }
    if (connect(sock_, (struct sockaddr *)&server, sizeof(server))==-1) {
        return 0;
    }
    return 1;
}

- (int)send_command:(NSString*)str
{
    NSLog(@"☆☆☆send_command");
    //    char cmd[] = "star";
    const char* cmd = [str UTF8String];
    int read_size;
    
    send( sock_, cmd, sizeof(cmd), 0);
    
    int len=1024;
    int revd_size;
    int tmp;
    revd_size=0;
    while(revd_size){
        tmp=recv(sock_,buf_+revd_size,len-revd_size,0);
        if(tmp==-1){ /* エラーが発生 */
            read_size=revd_size;
            return -1;
        }
        if(tmp==0){ /* ソケットが切断された */
            read_size=revd_size;
            return 0;
        }
        revd_size += tmp;
    }
    read_size = revd_size;
    
    return read_size;
}

- (int)close_socket
{
    NSLog(@"☆☆☆close_socket");
    shutdown(sock_, 2);
    return close(sock_);
}

- (bool)checkConnect
{
    bool check= [self connect_to_server];
    
    //connect
    if(check){
        [self send_command:@"star"];
    }
    [self close_socket];
    
    return check;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    //socket close
    [self close_socket];
    
    // オペレーションキューをリリース
    [queue_ release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
