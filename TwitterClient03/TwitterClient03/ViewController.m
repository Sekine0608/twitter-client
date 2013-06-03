//
//  ViewController.m
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/04/30.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
         if (granted) {
              self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    if (self.twitterAccounts > 0) {//登録済みアカウントであれば
                                                        ACAccount *account = [self.twitterAccounts lastObject];//初期値では最後に取得したアカウント
                                                        self.identifier = account.identifier; //この認証情報をほかの処理に使い回す
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.accountDisplayLabel.text = account.username; //usernameプロパティがユーザ名を表す
                                                        });
                                                    }
                                                    else { //登録済みのアカウントでなければ
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.accountDisplayLabel.text = @"アカウントなし";
                                                        });
                                                    }
                                                }
                                                else { //twitterAccoutを取得できなければ
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.accountDisplayLabel.text = @"アカウント認証エラー";
                                                    });
                                                }
                                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)setAccountAction:(id)sender { // アクションシート表示の定義
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    
    sheet.title = @"選択してください。";
    for (ACAccount *account in self.twitterAccounts) {
        [sheet addButtonWithTitle:account.username];
    }
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = self.twitterAccounts.count;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet  clickedButtonAtIndex:(NSInteger)buttonIndex { // アクションシート選択時の処理
    if (self.twitterAccounts.count > 0) {
        if (buttonIndex != self.twitterAccounts.count) {
            ACAccount *account = [self.twitterAccounts objectAtIndex:buttonIndex];
            self.identifier = account.identifier;
            self.accountDisplayLabel.text = account.username;
            NSLog(@"Account set! %@", account.username);
        }
        else {
            NSLog(@"cancel!");
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"timelineSegue"]){
        TimeLineTableViewController *timeLineTableViewController = [segue destinationViewController];
        timeLineTableViewController.identifier = self.identifier;
    }else if([[segue identifier] isEqualToString:@"favoriteSegue"]){
        FavoritesTableViewController *favoritesTableViewController = [segue destinationViewController];
        favoritesTableViewController.identifier = self.identifier;
    }
    
}


@end
