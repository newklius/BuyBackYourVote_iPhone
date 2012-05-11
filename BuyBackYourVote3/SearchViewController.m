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
#import "CompanyClarificationTableViewController.h"
#import "CompanyClarificationDataController.h"
#import "CompanyWebViewController.h"
#import "CompanySearch.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize companySearchQuery;
@synthesize actvityIndicator;
@synthesize oneSlug, oneName, searchDataController;
@synthesize clarificationDataController;

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
    
    // this doesn't handle cases well where there are multiple results. /search/exists should only be used for barcodes
    
    /*NSString *slugString = [NSString stringWithFormat:@"http://buybackyourvote.herokuapp.com/search/exists?company=%@", [[self.companySearchQuery.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"] lowercaseString]];
    
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
    else {*/
        // create a searchDataController with search results
    self.searchDataController = [[CompanySearchDataController alloc] initWithCompanyName:self.companySearchQuery.text];
    
    if ([self.searchDataController countOfCompanyList] == 1) {
        CompanySearch *companySearch = [searchDataController objectInCompanyListAtIndex:0];
        
        self.oneName = companySearch.companyName;
        self.oneSlug = companySearch.companyURL;
        [self performSegueWithIdentifier:@"CompanyResultsSegue" sender:self];
    } else if ([self.searchDataController countOfCompanyList] == 0) {
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No results" message: @"There were no companies that matched your search" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
    } else {
        [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];
    }
    //}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.companySearchQuery) {
        [textField resignFirstResponder];
    }
    [self processSearchQuery];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.companySearchQuery resignFirstResponder];
}

- (IBAction)scanButtonPressed:(id)sender {
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentModalViewController:reader animated:YES];    
    
}

- (void) processUPC:(NSString *)UPC {
    
    NSLog(@"starting to processUPC");
    
    // create Google URL query given barcode data
    NSString *query = [NSString stringWithFormat:@"https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyBOyGiUhBNy4v0zFaHvvbxsB-8It3Zl3p8&country=US&q=%@&alt=json", UPC];
    NSURL *url = [NSURL URLWithString:query];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *items = [jsonResults objectForKey:@"items"];
    NSString *thisBrand = @"";
    NSMutableDictionary *tally = [[NSMutableDictionary alloc] init];
    for (NSDictionary *item in items) {
        //NSLog(@"looping through items array: %d", i);
        thisBrand = [[item objectForKey:@"product"] objectForKey:@"brand"];
        // add thisbrand to tally
        if (thisBrand != NULL) {
            if ([tally valueForKey:thisBrand] == NULL)
                [tally setValue:[NSNumber numberWithInt:1] forKey:thisBrand];
            else {
                NSNumber *currentValue = [tally valueForKey:thisBrand];
                [tally setValue:[NSNumber numberWithInt:[currentValue intValue]+1] forKey:thisBrand];
            }
        }
    }
    
    // sort tally by Value
    //NSArray *sortedKeys = [tally keysSortedByValueUsingSelector:@selector(comparator)];
    
    NSArray *keys = [tally allKeys];
    NSString *key = @"";
    
    self.clarificationDataController = [[CompanyClarificationDataController alloc] init];
    
    NSString *slugString = @"http://buybackyourvote.herokuapp.com/search/exists?";
    NSString *slugURLConstruct = @"";
    for (key in keys) {
        // add each key to a URL thingy
        slugURLConstruct = [slugURLConstruct stringByAppendingString:[[[NSString stringWithFormat:@"company=%@&", [key stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] stringByReplacingOccurrencesOfString:@"\"" withString:@""] lowercaseString]];
        [self.clarificationDataController addCompanyWithName:key];
    }
    
    slugString = [slugString stringByAppendingString:slugURLConstruct];
    NSLog(@"%@",slugString);
    
    NSURL *slugURL = [NSURL URLWithString:slugString];
    NSData *slugJsonData = [NSData dataWithContentsOfURL:slugURL];
    NSArray *slugJsonArray = [NSJSONSerialization JSONObjectWithData:slugJsonData options:0 error:nil];
    
    self.searchDataController = [[CompanySearchDataController alloc] init];
    if ([slugJsonArray count] > 0) {
        if ([slugJsonArray count] == 1) {
            self.oneSlug = [[slugJsonArray objectAtIndex:0] objectForKey:@"slug"];
            self.oneName = [[slugJsonArray objectAtIndex:0] objectForKey:@"name"];
            NSLog(@"the slug = %@", self.oneSlug);
            [self performSegueWithIdentifier:@"CompanyResultsSegue" sender:self];
        }
        else {
            // get slugKeys from slugJsonResults
            for (NSDictionary *slug in slugJsonArray) {         
                [self.searchDataController addCompanyWithName:[slug objectForKey:@"name"] url:[slug objectForKey:@"slug"]];
            }
            [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];
        }
    }
    else {
        [self performSegueWithIdentifier:@"CompanyClarificationSegue" sender:self];
    }
}

- (void) imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissModalViewControllerAnimated: YES];
    
    [self processUPC:symbol.data];
}


@end
