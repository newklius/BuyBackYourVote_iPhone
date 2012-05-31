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
#import "CompanyTabViewController.h"
#import "CompanySearch.h"
#import "MBProgressHUD.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize companySearchQuery;
@synthesize oneSlug, oneName, searchDataController;
@synthesize clarificationDataController;
@synthesize mainWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:0.21 green:0.49 blue:0.21 alpha:1.0];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"main" ofType:@"html"]isDirectory:NO]]];
    self.mainWebView.scrollView.bounces = NO;
}

- (void)viewDidUnload
{
    [self setCompanySearchQuery:nil];
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
        CompanyTabViewController *tabViewController = [segue destinationViewController];
        tabViewController.companyURL = self.oneSlug;
        tabViewController.companyName = self.oneName;
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
    
    // this uses the normal search function now, since it's much faster than it used to be, and it is more
    // accurate for freeform text searches. The slug searcher is better for searching if it's a formal
    // company name
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.buybackyourvote.com/search/json?q=%@", [[self.companySearchQuery.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"] lowercaseString]]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.companySearchQuery) {
        [textField resignFirstResponder];
        [self processSearchQuery];
    }
    return YES;
}

- (IBAction)infoButtonPressed:(id)sender {
    NSLog(@"infobutton");
    [self performSegueWithIdentifier:@"InfoViewSegue" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
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
    NSURLRequest *request=[NSURLRequest requestWithURL: url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"Succeeded! Received %d bytes of data",[responseData
                                                   length]);
    
    if ([connection.currentRequest.URL.host isEqualToString:@"www.googleapis.com"]) { // it's searching for a UPC code
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
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
        
        NSArray *keys = [tally allKeys];
        NSString *key = @"";
        
        self.clarificationDataController = [[CompanyClarificationDataController alloc] init];
        
        NSString *slugString = @"http://www.buybackyourvote.com/search/exists?";
        NSString *slugURLConstruct = @"";
        for (key in keys) {
            // add each key to a URL thingy
            slugURLConstruct = [slugURLConstruct stringByAppendingString:[[[NSString stringWithFormat:@"company=%@&", [key stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] stringByReplacingOccurrencesOfString:@"\"" withString:@""] lowercaseString]];
            [self.clarificationDataController addCompanyWithName:key];
        }
        
        slugString = [slugString stringByAppendingString:slugURLConstruct];
        NSLog(@"%@",slugString);
        NSURL *slugURL = [NSURL URLWithString:slugString];
        NSURLRequest *request=[NSURLRequest requestWithURL: slugURL
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:60.0];
        // create the connection with the request
        // and start loading the data
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else { // it's searching through the search bar
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *slugJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
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
            /*// create a searchDataController with search results
             self.searchDataController = [[CompanySearchDataController alloc] initWithCompanyName:self.companySearchQuery.text];
             
             if ([self.searchDataController countOfCompanyList] == 1) {
             CompanySearch *companySearch = [searchDataController objectInCompanyListAtIndex:0];
             
             self.oneName = companySearch.companyName;
             self.oneSlug = companySearch.companyURL;
             [self performSegueWithIdentifier:@"CompanyResultsSegue" sender:self];
             } else if ([self.searchDataController countOfCompanyList] == 0) {*/
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No results" message: @"No companies that have made campaign contributions matched your search" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            
            [someError show];
            /*} else {
             [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];*/
        }
    }
}

- (IBAction)simulateButtonPressed:(id)sender {
    //NSString *polandSprings = @"075720481279";
    //NSString *honeyBunches = @"884912002181";
    //NSString *wheaties = @"016000275652";
    [self processUPC:@"016000275652"];
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
