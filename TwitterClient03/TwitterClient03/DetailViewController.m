//
//  DetailViewController.m
//  TwitterClient03
//
//  Created by 12cm0129 on 2013/05/07.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainQueue = dispatch_get_main_queue();
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
     
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                  @"/1.1/statuses/home_timeline.json"];
    NSDictionary *params = @{@"count" : @"20",
                             @"trim_user" : @"0",
                             @"include_entities" : @"0"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    //  Attach an account to the request
    [request setAccount:account];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    
    
    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            self.httpErrorMessage = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError;
                self.timelineData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (self.timelineData) {
                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if([[NSString stringWithFormat:@"%@",[[self.timelineData objectAtIndex:[self.index intValue]] objectForKey:@"favorited"]] isEqualToString:@"1"]){
                            self.favoriteOutlet.on = YES ;
                        }else{
                            self.favoriteOutlet.on = NO ;
                        }
                        
                    });
                    
                }
                else {
                    // Our JSON deserialization went awry
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
            }
            else {
                // The server did not respond successfully... were we rate-limited?
                self.httpErrorMessage =
                [NSString stringWithFormat:@"The response status code is %d", urlResponse.statusCode];
                NSLog(@"HTTP Error: %@", self.httpErrorMessage);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        });
    }];

	// Do any additional setup after loading the view.
    NSLog(@"%@", @"viewDidLoad") ;

    
    self.imageView.image = self.image;
    self.nameView.text = self.name;
    self.textView.text = self.text;
  
    
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favoriteAction:(id)sender {
    if(self.favoriteOutlet.on == NO){
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/destroy.json"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSDictionary *params = @{@"id" : self.idStr,
                                 @"include_entities" : @"true"} ;
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:url
                                                   parameters:params];
        
        //  Attach an account to the request
        [request setAccount:account];
        
        //  Execute the request
        [request performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse,
                                             NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                    NSDictionary *postResponseData =
                    [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:NSJSONReadingMutableContainers
                                                      error:NULL];
                    NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                }
                else {
                    NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                          [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                }
            }
            else {
                NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            }
        }];

    }else if(self.favoriteOutlet.on == YES){
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSDictionary *params = @{@"id" : self.idStr,
                                 @"include_entities" : @"true"} ;
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:url
                                                   parameters:params];
        
        //  Attach an account to the request
        [request setAccount:account];
        
        //  Execute the request
        [request performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse,
                                             NSError *error) {
            if (responseData) {
                NSInteger statusCode = urlResponse.statusCode;
                if (statusCode >= 200 && statusCode < 300) {
                    NSDictionary *postResponseData =
                    [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:NSJSONReadingMutableContainers
                                                      error:NULL];
                    NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                }
                else {
                    NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                          [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                }
            }
            else {
                NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            }
        }];

    }
    
}


- (IBAction)retweetAction:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.identifier];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", self.idStr];
    NSURL *url = [NSURL URLWithString:urlString];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:nil];
    
    //  Attach an account to the request
    [request setAccount:account];
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;

    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"replySegue"]){
        ReplyViewController *replyViewController = (ReplyViewController *)[segue destinationViewController];
    
        replyViewController.name = self.name;
        replyViewController.text = self.text;
        replyViewController.image = self.image;
        replyViewController.identifier = self.identifier;
        replyViewController.idStr = self.idStr ;
    }
}


@end
