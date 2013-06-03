//
//  DetailViewController.h
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/05/07.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "ReplyViewController.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSArray *timelineData;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *name ;
@property (nonatomic, copy)NSString *text ;
@property (nonatomic, copy)NSString *identifier ;
@property (nonatomic, copy) NSString *httpErrorMessage;
@property (nonatomic, copy) NSString *index;
 
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;

@property (nonatomic, copy)NSString *favorited ;
@property (nonatomic, copy)NSMutableArray *favoritedArray ;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *nameView;
@property (nonatomic, copy) NSString *idStr;

- (IBAction)retweetAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *favoriteOutlet;
- (IBAction)favoriteAction:(id)sender;

@end
