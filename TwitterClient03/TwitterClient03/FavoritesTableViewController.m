//
//  FavoritesTableViewController.m
//  TwitterClient03
//
//  Created by naoki sekine on 13/06/03.
//  Copyright (c) 2013年 12cm. All rights reserved.
//

#import "FavoritesTableViewController.h"

@interface FavoritesTableViewController ()

@end

@implementation FavoritesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
                  @"/1.1/favorites/list.json"];
    NSDictionary *params = nil;
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    //  Attach an account to the request
    [request setAccount:account];
    
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
                        [self.tableView reloadData];
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
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.timelineData) {
        return 1;
    } else {
        return [self.timelineData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (self.httpErrorMessage) {
        cell.textLabel.text = self.httpErrorMessage; // httpエラー時にはここにメッセージ表示
    } else if (!self.timelineData) {
        cell.textLabel.text = @"Loading...";
    } else {
        NSString *name = [[[self.timelineData objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"screen_name"];
        NSString *text = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = text;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.text = name;
        cell.textLabel.numberOfLines = 0; 
        cell.imageView.image = [UIImage imageNamed:@"blank.png"];
        
        dispatch_async(self.imageQueue, ^{
            NSString *url = [[[self.timelineData objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"profile_image_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(self.mainQueue, ^{
                cell.imageView.image = img;
                [cell setNeedsLayout];
            });
        });
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
                           constrainedToSize:CGSizeMake(300, 1000)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 35;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
