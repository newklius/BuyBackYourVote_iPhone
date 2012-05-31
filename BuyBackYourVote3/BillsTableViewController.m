//
//  BillsTableViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BillsTableViewController.h"
#import "Bill.h"
#import "BillDetailViewController.h"
#import "Company.h"
#import "MBProgressHUD.h"

@interface BillsTableViewController ()

@end

@implementation BillsTableViewController

@synthesize bills, company;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.bills = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.bills count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bill = [self.bills objectAtIndex:indexPath.row];
    NSString *disposition = [bill objectForKey:@"disposition"];
    NSString *cellIdentifier = @"BillCell";
    
    if ([disposition isKindOfClass:[NSString class]]) {
        if ([disposition isEqualToString:@"support"]) {
            cellIdentifier = @"SupportBillCell";
        } else {
            cellIdentifier = @"OpposeBillCell";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	// Set up the cell.
	
    
    NSString *measure = [[bill objectForKey:@"measure"] stringByReplacingOccurrencesOfString:@"<sup>" withString:@""];
    measure = [measure stringByReplacingOccurrencesOfString:@"</sup>" withString:@""];
    
    if ([disposition isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@s %@", [disposition capitalizedString], measure];
    } else {
        cell.textLabel.text = measure;
    }
    
    cell.detailTextLabel.text = [bill objectForKey:@"topic"];

    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [ [ NSURL alloc ] initWithString: [[self.bills objectAtIndex:indexPath.row] objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:url];
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BillSegue"]) {
        
        BillDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.bill = [self.bills objectAtIndex:[self.tableView indexPathForSelectedRow].row];

    }
}*/

- (void)loadFromCompany:(Company *)comp {
    self.company = comp;
    if ([self.bills count] == 0) {
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [self.company loadDataFromAction:@"bills/json" delegate:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No results" message: @"There was a network error" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    
    [someError show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[responseData
                                                   length]);
    
    NSInteger billsCount = [self.bills count];
    
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    
    [[self tableView] beginUpdates];
    
    self.bills = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil] objectForKey:@"positions"];
    
    NSMutableArray *insertArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    
    int i;
    for (i = 0; i < billsCount; i++) {
        [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    i = 0;
    for (id item in self.bills) {
        [insertArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
    }
    
    //[self.tableView reloadData];
    [[self tableView] deleteRowsAtIndexPaths:(NSArray *)deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] insertRowsAtIndexPaths:(NSArray *)insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
    /*if ([self.children count] == 0) {
     [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
     }*/
    [[self tableView] endUpdates];
}

@end
