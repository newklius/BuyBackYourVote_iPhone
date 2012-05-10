//
//  SecondViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

#import "CompanySearchTableViewController.h"
#import "CompanySearchDataController.h"
#import "CompanyWebViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize companySearchQuery;
@synthesize actvityIndicator;
@synthesize oneSlug, oneName, searchDataController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:0.21 green:0.49 blue:0.21 alpha:1.0];
}

- (void)viewDidUnload
{
    [self setCompanySearchQuery:nil];
    [self setActvityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)searchButtonTapped:(id)sender {
    [self processSearchQuery];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{    
    if ([[segue identifier] isEqualToString:@"CompanyResultsSegue"]) {
        CompanyWebViewController *webViewController = [segue destinationViewController];
        webViewController.companyURL = self.oneSlug;
        webViewController.companyName = self.oneName;
    }    
    else if ([[segue identifier] isEqualToString:@"CompanySearchSegue"]) {
        CompanySearchTableViewController *searchViewController = [segue destinationViewController];
         searchViewController.searchDataController = self.searchDataController;        
    }
}

- (void)processSearchQuery {
    
    // run the slug request
    // 0 results: show regular search page
    // 1 result: go directly to result page
    // 2+ results: show search page with slugs
    
    /* examples:
     Nabisco: parent and child
     Jif: no slug result; shows list
     General Mills: goes directly
     */
    
    NSString *slugString = [NSString stringWithFormat:@"http://buybackyourvote.herokuapp.com/search/exists?company=%@", [[self.companySearchQuery.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"] lowercaseString]];
    
    NSURL *slugURL = [NSURL URLWithString:slugString];
    NSData *slugJsonData = [NSData dataWithContentsOfURL:slugURL];
    NSArray *slugJsonArray = [NSJSONSerialization JSONObjectWithData:slugJsonData options:0 error:nil];
    
    if ([slugJsonArray count] > 0) {
        if ([slugJsonArray count] == 1 ) {
            self.oneSlug = [[slugJsonArray objectAtIndex:0] objectForKey:@"slug"];
            self.oneName = [[slugJsonArray objectAtIndex:0] objectForKey:@"name"];
            NSLog(@"the slug = %@", self.oneSlug);
            [self performSegueWithIdentifier:@"CompanyResultsSegue" sender:self];
        }
        else {
            self.searchDataController = [[CompanySearchDataController alloc] init];
            // get slugKeys from slugJsonResults
            for (NSDictionary *slug in slugJsonArray) {         
                [self.searchDataController addCompanyWithName:[slug objectForKey:@"name"] url:[slug objectForKey:@"slug"]];
            }
            [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];
        }
    }
    else {
        // create a searchDataController with search results
        self.searchDataController = [[CompanySearchDataController alloc] initWithCompanyName:self.companySearchQuery.text];       
        [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.companySearchQuery) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end
