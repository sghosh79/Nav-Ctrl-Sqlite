//
//  ChildViewController.m
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/23/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.wbc = [[WebViewController alloc] init];


}


- (void)viewWillAppear:(BOOL)animated
{
    //viewWill Appear Notifies the view controller that its view is about to be added to a view hierarchy.
    // animated - If YES, the view is being added to the window using an animation.

    
    [super viewWillAppear:animated];
    //  [self.dataAccess2 test];
    // viewWillAppear: Notifies the view controller that its view is about to be added to a view hierarchy.
    // animated - If YES, the view is being added to the window using an animation.
  
    
    [self.tableView reloadData];
    //tableView: returns the table view managed by the controller object (ChildViewController).
    //Reloads the rows and sections of the receiver.

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    return [self.company.products count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int row = indexPath.row;
    NSLog(@"Cell at index: %d", row);
    
    Product *product = [self.company.products objectAtIndex: row];
    
    cell.textLabel.text = product.name;
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //instead of removing object at this index, I'll call a method in DataAccess to remove the object instead
    
    
    
    [self.dataAccess2 deleteCompany:self.company andDeleteProduct:indexPath];
    
    //  [self.company.products removeObjectAtIndex:indexPath.row];
    
    
    [self.tableView reloadData];
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSLog(@"Cell at index: %d", row);
    
    Product *product = [self.company.products objectAtIndex: row];
    
    self.wbc.productURL = product.website;
    
    [self.navigationController pushViewController:self.wbc animated:YES];
    
    
    
}


//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
