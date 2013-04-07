//
//  GameSettings.h
//  TCP_connect
//
//  Created by roikawa on 13/03/31.
//
//

#import <Foundation/Foundation.h>
#import "sys/socket.h"
#import "netinet/in.h"
#import "netinet6/in6.h"
#import "arpa/inet.h"
#import "ifaddrs.h"
#import "netdb.h"

@interface GameSettings : NSObject{
    //host
    NSString* ip_addr_;
    int port_host_;
    
    int sock_;
    char buf_[1024];
    
    NSOperationQueue *queue_;
}

+(GameSettings*) sharedSettings;

@property NSString* ip_addr;
@property int port_host;
@property NSOperationQueue *queue;

- (int)connect_to_server;
- (int)send_command:(NSString*)str;
- (int)close_socket;
- (bool)checkConnect;

@end
