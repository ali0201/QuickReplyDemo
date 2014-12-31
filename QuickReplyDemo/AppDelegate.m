//
//  AppDelegate.m
//  QuickReplyDemo
//
//  Created by Kevin on 14/12/31.
//  Copyright (c) 2014年 HGG. All rights reserved.
//
//  源码参考了 http://blog.devzeng.com/blog/ios8-notification-reply.html
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建消息上要添加的动作，以按钮的形式显示
    
    //接受按钮
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"acceptAction";
    acceptAction.title = @"接受";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    
    //拒绝按钮
    UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
    rejectAction.identifier = @"rejectAction";
    rejectAction.title = @"拒绝";
    rejectAction.activationMode = UIUserNotificationActivationModeBackground;
    rejectAction.authenticationRequired = YES;  // 需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    rejectAction.destructive = YES;
    
    // 2.创建动作（按钮）的类别集合
    UIMutableUserNotificationCategory *categories = [[UIMutableUserNotificationCategory alloc] init];
//    categories.identifier = @"alert";
    categories.identifier = @"default";
    NSArray *actions = @[acceptAction,rejectAction];
    [categories setActions:actions forContext:UIUserNotificationActionContextMinimal];
    
    // 3.创建UIUserNotificationSettings，并设置消息的显示类型
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categories, nil]];
    
    // 4.注册推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 在使用Push的时候需要在数据包中加入特定的Category字段（字段内容需要前后端定义为一致）,终端接收到到后，就能展示上述代码对应Category设置的按钮，和响应按钮事件。
    //  {"aps":{"alert":"测试推送的快捷回复", "sound":"default", "badge": 1, "category":"alert"}}
    
    // 5.发起本地通知事件
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.alertBody = @"测试推送的快捷回复";
//    notification.category = @"alert";
    notification.alertBody = @"sound";
    notification.category = @"default";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%@", notificationSettings);
}

/**
 *  运行之后要按shift + command + H，让程序推到后台，或者按command+L让模拟器锁屏，才会看到效果！如果是程序退到后台了，收到消息后下拉消息，则会出现刚才添加的两个按钮；如果是锁屏了，则出现消息后，左划就会出现刚才添加的两个按钮。
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    // 在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    NSLog(@"%@----%@",identifier,notification);
    // 处理完消息，最后一定要调用这个代码块
    completionHandler();
}


@end
