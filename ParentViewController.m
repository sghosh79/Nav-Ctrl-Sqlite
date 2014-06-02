//
//  ParentViewController.m
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/23/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import "ParentViewController.h"
#import "ChildViewController.h"
#import "DataAccess.h"
#import "sqlite3.h"



@interface ParentViewController ()
{
    
    NSMutableArray *arrayOfProducts;
    NSMutableArray *arrayOfCompanies;
    sqlite3 *productDB;
    sqlite3 *companyDB;
    
}


@end

@implementation ParentViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//- (void)didReceiveMemoryWarning //needed to remove this bc it was causing an error
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    arrayOfProducts = [[NSMutableArray alloc] init];
    
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
    
    
    //initially omitted code to set delegate and data source for table view bc we did it manually w Interface Builder (went back of some weird error)
    
    //initialize the Data Access object and then call its SetCompanyListFromDB method
    
    // Previously forgot this part
    // Make my data ready
    self.dataAccess = [[DataAccess alloc] init];
    [self.dataAccess setCompanyListFromDB];
    
    
    
    self.childVC = [[ChildViewController alloc] init];
    
    
    //dynamically set up asynchronous get request
    
    NSMutableString *urlQuotes = [NSMutableString stringWithString:@"http://download.finance.yahoo.com/d/quotes.csv?s="];
    
    //stringWithString --> Returns a string created by copying the characters from another given string.
    //stringWithFormat --> Returns a string created by using a given format string as a template into which the remaining argument values are substituted.
    
    
    for(int i =0; i<self.dataAccess.companyList.count; i++) {
        Company *company = self.dataAccess.companyList[i];
        [urlQuotes appendFormat:@"%@", company.stockSymbol];
        //apendFormat - Adds a constructed string to the receiver.
        
        if(i<self.dataAccess.companyList.count-1)
        {       [urlQuotes appendString:@","];
        }
    }
    
    [urlQuotes appendString:@"&f=l1,"];
    
    NSLog(@"Quote URL: %@", urlQuotes);
    
    
    _responseData =[[NSMutableData alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:urlQuotes]] ; //we are creating the request here
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //we are creating the url connection and firing the request here
    [conn start]; //start the connection
    
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //description of method: asks the data source to return the number of sections in the table view.
    //parameter: An object representing the table view requesting this information.
    //returns: The number of sections in tableView. The default value is 1.
    
    NSLog(@"numberOfSectionsInTableView");
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    
    //description: tells the data source to return the number of rows in a given section of a table view
    //parameters: tableView - the table-view object requesting this information; section: an index number identifying a section in tableView.
    //returns the number of rows in the section
    
    return [self.dataAccess.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    //The UITableViewCell class defines the attributes and behavior of the cells that appear in UITableView objects. This class includes properties and methods for setting and managing cell content and background (including text, images, and custom views), managing the cell selection and highlight state, managing accessory views, and initiating the editing of the cell contents.
    //UITableView: is an instance of UITableView (or simply, a table view) is a means for displaying and editing hierarchical lists of information.
    //Asks the data source for a cell to insert in a particular location of the table view. (required) The returned UITableViewCell object is frequently one that the application reuses for performance reasons. You should fetch a previously created cell object that is marked for reuse by sending a dequeueReusableCellWithIdentifier: message to tableView. Various attributes of a table cell are set automatically based on whether the cell is a separator and on information the data source provides, such as for accessory views and editing controls.
    
    static NSString *CellIdentifier = @"Cell";
    
    //dequeueReusableCellWithIdentifier: Returns a reusable table-view cell object located by its identifier.
    //parameter (in this case CellIdentifier): A string identifying the cell object to be reused. This parameter must not be nil.
    //returns: a UITableViewCell object with the associated identifier or nil if no such object exists in the reusable-cell queue.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    int row = indexPath.row;
    NSLog(@"Cell at index: %d", row);
    
//    the row property/variable above in indexPath.row is an index number identifying a row in a section of a table view.
//    The section the row is in is identified by the value of section.

    
    //Find the company for this row in the table
    Company * company = self.dataAccess.companyList[row];
    NSLog(@"Got company %@ at index: %d from companyList Array", company.name, row);
    
    // Configure the cell...
    
    //make the row's text be the company's name
    cell.textLabel.text = company.name;
    [[cell imageView] setImage: [UIImage imageNamed: company.logo]];
    cell.detailTextLabel.text = company.stockPrice;
    
    
    return cell;
}

//interesting Unkown classViewController in Interface Builder file error, from deleting original ViewController and then recreating it: http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    NSLog(@"Cell at index: %d", row);
    self.childVC.company = self.dataAccess.companyList[row];
    //  [self.dataAccess test];
    self.childVC.dataAccess2 = self.dataAccess;
    [self.navigationController pushViewController:self.childVC animated:YES];
}




#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString *str =  [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSMutableArray *responseArray= [NSMutableArray arrayWithArray:   [str componentsSeparatedByString:@"\n"]  ];
    
    //includes extra blank character at the end; just leaving it there for now
    NSLog(@"Response Array: %@", responseArray);
    
//    for(int i=0;i<[self.dataAccess.companyList count];i++){
//        Company *company = self.dataAccess.companyList[i];
//        NSMutableString *string = responseArray[i];
    for(int i=0;i<[self.dataAccess.companyList count] && i<[responseArray count];i++){
        Company *company = self.dataAccess.companyList[i];
        NSMutableString *string = responseArray[i];
        NSLog(@"adding stock price: %@ to company at index %d", string, i);
        company.stockPrice = string;
        
    } //simple loop for referring to items in companyList
    
    
    [self.tableView reloadData];
    
    
    NSLog (@"connectionDidFinishLoading Done");
    
    
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog (@"connection didFailWithError: %@", error.debugDescription);

    //Description: returns a string that describes the contents of the receiver for presentation in the debugger.
    //Returns a string that describes the contents of the receiver for presentation in the debugger.
    
    
}



@end