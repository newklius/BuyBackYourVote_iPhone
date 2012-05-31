//
//  CompanyViewController.m
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/25/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyTabViewController.h"
#import "Company.h"
#import "MBProgressHUD.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController
@synthesize company, children, informationItems, parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.children = [[NSArray alloc] init];
        self.informationItems = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of     sections.
    //if ([self.children count] == 0 || [self.informationItems count] == 0)
        return 2;
    //else
    //    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [billsDataController countOfBillsList];
    if (section == 0)
        return [self.informationItems count];
    else
        return [self.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {// child companies
        static NSString *CellIdentifier = @"ChildCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            // Use the default cell style.
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Set up the cell.
        NSDictionary *child = [self.children objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [child objectForKey:@"name"];
        
        return cell;
    } else { // information about the company
        NSArray *item = [self.informationItems objectAtIndex:indexPath.row];
        NSString *label = [item objectAtIndex:0];
        NSString *CellIdentifier = @"InfoCell";
        
        if ([label isEqualToString:@"Parent"]) {
            CellIdentifier = @"ParentCell";
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            // Use the default cell style.
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Set up the cell.
        
        cell.textLabel.text = label;
        cell.detailTextLabel.text = [item objectAtIndex:1];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return self.company.companyName;
    else
        return @"Subsidiaries";
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
        
- (void)loadFromCompany:(Company *)comp {
    self.company = comp;
    if ([self.informationItems count] == 0) {
        [self.company loadDataFromAction:@"json" delegate:self];
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
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
    
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    NSInteger informationItemsCount = [self.informationItems count];
    NSInteger childrenCount = [self.children count];
    NSLog([NSString stringWithFormat:@"%d", informationItemsCount]);
    NSLog([NSString stringWithFormat:@"%d", childrenCount]);
    
    NSString* sector = [jsonResults objectForKey:@"sector"];
    if (![sector isEqualToString:@""])
        [info addObject:[NSArray arrayWithObjects:@"Sector", sector, nil]];
    NSString* industry = [jsonResults objectForKey:@"industry"];
    if (![industry isEqualToString:@""])
        [info addObject:[NSArray arrayWithObjects:@"Industry", industry, nil]];
    NSString* logoURL = [jsonResults objectForKey:@"logo"];
    NSString* location = [jsonResults objectForKey:@"location"];
    while ([location hasPrefix:@", "]) {
        location = [location substringFromIndex:2];
    }
    if (![location isEqualToString:@""])
        [info addObject:[NSArray arrayWithObjects: @"Location", location, nil]];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *contribution_sum = [f numberFromString:[jsonResults objectForKey:@"contribution_sum"]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@"$"];
    NSString *totalString = [formatter stringFromNumber:contribution_sum];
    [info addObject:[NSArray arrayWithObjects: @"Spent", totalString, nil]];
    NSDictionary *parentDict = [jsonResults objectForKey:@"parent"];
    if ([parentDict isKindOfClass:[NSDictionary class]]) {
        self.parent = parentDict;
        [info addObject:[NSArray arrayWithObjects: @"Parent", [self.parent objectForKey:@"name"], nil]];
    }
    
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    
    [[self tableView] beginUpdates];
    
    self.children = [jsonResults objectForKey:@"children"];
    self.informationItems = [NSArray arrayWithArray:info];
    
    NSMutableArray *insertArray = [[NSMutableArray alloc] init];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    
    int i;
    for (i = 0; i < informationItemsCount; i++) {
        [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    for (i = 0; i < childrenCount; i++) {
        [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    i = 0;
    for (id item in self.informationItems) {
        [insertArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
    }
    i = 0;
    for (NSDictionary* child in self.children) {
        [insertArray addObject:[NSIndexPath indexPathForRow:i++ inSection:1]];
    }
    
    //[self.tableView reloadData];
    [[self tableView] deleteRowsAtIndexPaths:(NSArray *)deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] insertRowsAtIndexPaths:(NSArray *)insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
    /*if ([self.children count] == 0) {
        [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }*/
    [[self tableView] endUpdates];
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CompanySegue"]) {
        
        CompanyTabViewController *tabController = [segue destinationViewController];
        tabController.companyURL = [[self.children objectAtIndex:[self.tableView indexPathForSelectedRow].row] objectForKey:@"slug"];
        tabController.companyName = [[self.children objectAtIndex:[self.tableView indexPathForSelectedRow].row] objectForKey:@"name"];
    } else if ([[segue identifier] isEqualToString:@"ParentSegue"]) {
        
        CompanyTabViewController *tabController = [segue destinationViewController];
        tabController.companyURL = [self.parent objectForKey:@"slug"];
        tabController.companyName = [self.parent objectForKey:@"name"];
    }
}

@end
