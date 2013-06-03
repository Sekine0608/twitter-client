//
//  FavoritesTableViewController.h
//  TwitterClient03
//
//  Created by naoki sekine on 13/06/03.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface FavoritesTableViewController : UITableViewController
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;
@property (nonatomic, strong) NSArray *timelineData;
@property (nonatomic, copy) NSString *httpErrorMessage;
@property (nonatomic, copy) NSString *identifier;


@end
