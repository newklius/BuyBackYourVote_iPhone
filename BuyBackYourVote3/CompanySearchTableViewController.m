//
//  CompanySearchTableViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanySearchTableViewController.h"

#import "CompanyResultsViewController.h"
#import "CompanySearchDataController.h"
#import "CompanySearch.h"
#import "Company.h"
#import "CompanyTabViewController.h"
#import "IconDownloader.h"

@interface CompanySearchTableViewController ()

@end

@implementation CompanySearchTableViewController

@synthesize searchDataController, imageDownloadsInProgress;

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
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.hidden = NO;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    return [searchDataController countOfCompanyList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanySearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	// Set up the cell.
	CompanySearch *companySearch = [searchDataController objectInCompanyListAtIndex:indexPath.row];
    
    cell.textLabel.text = companySearch.companyName;
    if (companySearch.companySum != nil) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencySymbol:@"$"];
        [formatter setMaximumFractionDigits:0];
        cell.detailTextLabel.text = [formatter stringFromNumber:companySearch.companySum];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (!iconDownloader || !iconDownloader.image)
    {
        NSString *url = companySearch.companyLogo;
        if (url == (id)[NSNull null]) {
            NSString *slug = companySearch.companyURL;
            url = [NSString stringWithFormat:@"http://www.buybackyourvote.com/company/json/%@", slug];
        }
        if (![url isEqualToString:@""]) {
            [self startIconDownload:url forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        UIImage *i = [UIImage imageNamed:@"blank.png"];
        CGSize itemSize = CGSizeMake(48, 48);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, [[UIScreen mainScreen] scale]);
        CGRect imageRect = CGRectMake(0.0, 0.0, 48, 48);
        [i drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        cell.imageView.image = iconDownloader.image;
    }
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.frame = CGRectMake(0, 0, cell.imageView.image.size.width, cell.imageView.image.size.height);
    cell.indentationLevel = 0;
    
    return cell;
}

- (void)startIconDownload:(NSString *)url forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.url = url;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.image;
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.frame = CGRectMake(0, 0, 44, 44);
    }
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


// add in segue function to load ComanyReultsViewController with the company name
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CompanyResultsSegue"]) {

        CompanyTabViewController *tabViewController = [segue destinationViewController];
        tabViewController.companyURL = [self.searchDataController objectInCompanyListAtIndex:[self.tableView indexPathForSelectedRow].row].companyURL;
        tabViewController.companyName = [self.searchDataController objectInCompanyListAtIndex:[self.tableView indexPathForSelectedRow].row].companyName;
        /*
        NSLog(@"segueing");
        
        CompanyResultsViewController *resultsViewController = [segue destinationViewController];

        NSLog(@"set segue view controller");
        
        Company *theCompany = [[Company alloc] initWithName:[self.searchDataController objectInCompanyListAtIndex:[self.tableView indexPathForSelectedRow].row].companyName];
        NSLog(@"inited company with name: %@", theCompany.companyName);
        
        resultsViewController.company = theCompany;
        NSLog(@"now segueing");
         */
    }
}


@end
