//
//  ViewController.m
//  Socket
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//
#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self socketDemo];



}

-(void)socketDemo{
    /***************************1、创建**************************/
    /*
     * domain: 协议域 AF_INET -> IPV4
     * type: socket类型 SOCK_STREAM/SOCK_DGRAM
     * protocol: 协议IPPROTO_TCP 如果是0，会自动更新到第二个参数，选择合适的协议
     * 返回值 socket
     */
    int clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

    /***************************2、连接**************************/
    /**
     参数
     1> 客户端socket
     2> 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号
     */
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(12345);
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    //在C语言开发中，经常传递一个数据的指针，还需要指定数据的长度
    int connResult = connect(clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    if (connResult == 0) {
        NSLog(@"成功连接");
    }else{
        NSLog(@"连接失败: %d", connResult);
        return;
    }
//    $ nc -lk 12345
//    始终监听本地计算机12345端口的数据


    /***************************3、发送**************************/
    /**
     参数
     1> 客户端socket
     2> 发送内容地址
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    const char *sendMessage = "hello";
    ssize_t sendLen = send(clientSocket, sendMessage, strlen(sendMessage), 0);
    NSLog(@"发送了 %zd 个字节", sendLen);

    /***************************4、读**************************/
    /**
     参数
     1> 客户端socket
     2> 接收内容缓冲区地址
     3> 接收内容缓存区长度
     4> 接收方式，0表示阻塞，必须等待服务器返回数据
     返回值
     如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
     */
    //提前准备的空间
    uint8_t buffer[1024];

    ssize_t recvLen = recv(clientSocket, &buffer, sizeof(buffer), 0);

    NSLog(@"接收到了 %zd 个字节", recvLen);

    NSData *data = [NSData dataWithBytes:buffer length:recvLen];

    NSString *recvMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"接收到的内容是 %@", recvMessage);

    /***************************5、关闭**************************/
    // 关闭socket
    close(clientSocket);
    
    
}


@end
