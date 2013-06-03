//
//  ReplyViewController.h
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/05/31.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ReplyViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *identifier;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *nameView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *idStr;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;

- (IBAction)replyAction:(id)sender;

@end
