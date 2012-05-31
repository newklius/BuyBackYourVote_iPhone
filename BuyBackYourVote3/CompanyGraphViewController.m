    //
//  CompanyViewController.m
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/25/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import "CompanyGraphViewController.h"
#import "Company.h"
#import "Candidate.h"
#import "MBProgressHUD.h"
#import "FilterViewController.h"
#import "Contributions.h"

@interface CompanyGraphViewController ()

@end

@implementation CompanyGraphViewController
@synthesize company, contributions, contributionsByYear, years, groupingFilter, yearFilter, seatFilter, stateFilter;

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
    self.years = [NSArray arrayWithObjects:[NSNumber numberWithInt:2012], nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadFromCompany:(Company *)comp {
    self.company = comp;
    if (![self.contributions isMemberOfClass:[Contributions class]]) {
        self.contributionsByYear = [[NSMutableDictionary alloc] init];
        self.groupingFilter = @"party";
        self.seatFilter = nil;
        self.stateFilter = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.company loadDataFromAction:@"candidates" delegate:self];
        [self.company loadDataFromAction:@"company_cycle_range" delegate:self];
    }
}

- (void)filterButton {
    [self performSegueWithIdentifier:@"FilterSegue" sender:self];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No results" message: @"There was a network error" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    
    [someError show];
}

- (void)loadContributionsWithYear:(NSNumber *)year {
    yearFilter = year;
    Contributions *c = [self.contributionsByYear objectForKey:year];
    if (![c isMemberOfClass:[Contributions class]]) {
        // download year
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.company loadDataFromAction:@"candidates" extra:[NSString stringWithFormat:@"%d", [year intValue]] delegate:self];
    } else {
        // update table right away
        NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
        NSMutableArray *insertArray = [[NSMutableArray alloc] init];
        
        [[self tableView] beginUpdates];
        
        int i = 0;
        for (id item in self.contributions.list) {
            [deleteArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        }
        
        contributions = c;
        [contributions filterWithGrouping:groupingFilter state:stateFilter seat:seatFilter];
        
        i = 0;
        for (id item in c.list) {
            [insertArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        }
        
        [[self tableView] deleteRowsAtIndexPaths:(NSArray *)deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self tableView] insertRowsAtIndexPaths:(NSArray *)insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [[self tableView] endUpdates];

    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[responseData
                                                   length]);
    // cycle list
    if ([connection.currentRequest.URL.path hasPrefix:@"/company/company_cycle_range"]) {
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        self.years = [jsonResults objectForKey:@"cycles"];
        yearFilter = [self.years lastObject];
        if ([self.contributions isMemberOfClass:[Contributions class]]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.contributionsByYear setObject:self.contributions forKey:yearFilter];
        }
    } else {
        NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
        NSMutableArray *insertArray = [[NSMutableArray alloc] init];

        int i = 0;
        for (id item in self.contributions.list) {
            [deleteArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        }
        
        [[self tableView] beginUpdates];
        
        NSLog(groupingFilter);
        
        contributions = [[Contributions alloc] initWithJSON:responseData];
        [contributions filterWithGrouping:groupingFilter state:stateFilter seat:seatFilter];
        
        i = 0;
        for (id item in self.contributions.list) {
            [insertArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        }
        
        NSLog([NSString stringWithFormat:@"%d", i]);
        
        if (self.yearFilter != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.contributionsByYear setObject:self.contributions forKey:yearFilter];
        }
        
        [[self tableView] deleteRowsAtIndexPaths:(NSArray *)deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self tableView] insertRowsAtIndexPaths:(NSArray *)insertArray withRowAnimation:UITableViewRowAnimationAutomatic];

        [[self tableView] endUpdates];
    }
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
    return [self.contributions.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *contribution = [self.contributions.list objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"ContributionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	// Set up the cell.
    
    cell.detailTextLabel.text = [contribution objectAtIndex:0];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@"$"];
    
    cell.textLabel.text = [formatter stringFromNumber:[contribution objectAtIndex:1]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FilterSegue"]) {
        
        FilterViewController *filterController = [segue destinationViewController];
        filterController.years = self.years;
        filterController.graphController = self;
    }
}



@end
