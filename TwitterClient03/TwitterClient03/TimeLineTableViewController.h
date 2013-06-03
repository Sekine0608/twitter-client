//
//  TimeLineTableViewController.h
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/04/30.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "DetailViewController.h"

@interface TimeLineTableViewController : UITableViewController
 
@property (nonatomic, strong) NSArray *timelineData;
@property (nonatomic, copy) NSString *httpErrorMessage;
@property (nonatomic, copy) NSString *identifier;
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;

@end
