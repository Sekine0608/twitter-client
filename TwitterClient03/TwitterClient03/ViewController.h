//
//  ViewController.h
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/04/30.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TimeLineTableViewController.h"
#import "FavoritesTableViewController.h"


@interface ViewController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountDisplayLabel;
@property (nonatomic, strong)ACAccountStore *accountStore ;
@property (nonatomic, strong)NSArray *twitterAccounts ;
@property (nonatomic, copy)NSString *identifier ;

- (IBAction)setAccountAction:(id)sender;


@end
