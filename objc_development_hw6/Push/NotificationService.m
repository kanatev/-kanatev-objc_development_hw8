//  NotificationService.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 29.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.

#import "NotificationService.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationService() <UNUserNotificationCenterDelegate>

@end

@implementation NotificationService


+(instancetype)sharedInstance {
    static NotificationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[NotificationService alloc] init];
    });
    return service;
}

-(void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    
    //запрос разрешения пользователя на уведомления
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Пользователь не дал доступ");
        }
    }];
}

-(void)sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    if(notification.imageURL) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:notification.imageURL options:nil error:nil];
        
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    
    NSDateComponents *newComponents = [NSDateComponents new];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    newComponents.second = components.second;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:false];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date, NSURL* _Nullable url) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageURL = url;
    return notification;
}

@end
