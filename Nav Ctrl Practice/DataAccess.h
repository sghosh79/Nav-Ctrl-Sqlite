//
//  DataAccess.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/19/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Company.h"
#import "sqlite3.h"

@interface DataAccess : NSObject
{

    sqlite3 *companyDB; ///sqlite3 is a library; gives you access to an object that has the tools to interact with the database, personDB is a variable that represents the library
    
}


@property (nonatomic, retain) NSString *dbPathString; //had to convert this from a regular variable located in the interface section to a property

@property (nonatomic, retain) NSMutableArray *companyList; //create a companyList array

@property (nonatomic, retain) UITableView *myTableView; //create a Tableview

-(void) setCompanyListFromDB; //set companyList array elements equal to relevant companies

-(void) createDBFile;

-(NSMutableArray*) readCompanyDataFromDB; //use this before setting companyList

-(NSMutableArray*) readProductDataFromDBForCompanyID:(NSString*)companyId;

-(void)deleteCompany:(Company *) company andDeleteProduct:(NSIndexPath *) indexPath;

//-(void) deleteProductFromDB:(NSString*)productname;


@end
