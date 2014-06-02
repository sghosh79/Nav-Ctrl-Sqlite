//
//  DataAccess.m
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/19/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import "DataAccess.h"


@implementation DataAccess

//NSString *dbPathString;
//sqlite3 *companyDB; if this is in the h file you need to keep the sqlite3 section in brackets after the @interface DataAccess:NSObject
//sqlite3 *productDB;



-(void) setCompanyListFromDB; //invoke createDBFile; then set the property of self.companyList = [self readCompanyDataFromDB] which returns an nsmutable array
{
    NSLog(@"setCompanyListFromDB"); //put in NSLogs to see if this is being called and runs
    
    [self createDBFile]; //invoke createDBFile, in order to set the company list array you need to acutally create the dbfile
    
    self.companyList = [self readCompanyDataFromDB]; //invoke readCOmpanyDatacreateDBFile; then set the property of self.companyList = [self readCompanyDataFromDB] which returns an nsmutable array

    
    NSLog(@"read all company data"); //put in NSLog to see if previous methods were called and executed
    
    
}


-(void) deleteCompany:(Company *)company andDeleteProduct:(NSIndexPath *)indexPath{
    //parameters --> we're just defining the method
    //pass the company from the tableview, then pass the row from the tablewview
    
    Product *product = [company.products objectAtIndex:indexPath.row];

//  Returns the object located at the specified index. If index is beyond the end of the arra,y an NSRangeException is raised.
//  product object is equal to the objectAtIndex numbered indexPath.row basedon the company specified in the above parameter - in particular the deleteCompany:(Company *)company portion
    
    
    
    [self deleteProductFromDB:product.name]; //calling a method we hadn't named in h file before (this has a NSString parameter)
    
    
    
    
    [company.products removeObjectAtIndex:indexPath.row];
    
    //removes the object at index .
    
}

-(void) createDBFile {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//array of various directories/strings
    
    //NSSearchPathForDirectoriesInDomains creates a list of directory search paths. Creates a list of path strings for the specified directories in the specified domains. The list is in the order in which you should search the directories. If expandTilde is YES, tildes are expanded as described in stringByExpandingTildeInPath
    
    
    //NSDocumentDirectory: Document Directory
    //NSUserDomainMask: The user’s home directory—the place to install user’s personal items (~).

    NSString *docPath = [path objectAtIndex:0]; //returns the object at location zero; docpath returns first item in the list of directories that nssearchpathfordirectories gives us
    
    //  dbPath = docPath;
    
    self.dbPathString = [docPath stringByAppendingPathComponent:@"telecom.db"]; ////appends telecom.db to docpath, docpath is just a folder so we need to tell it what file we want which is telecom.db
    // stringByAppendingPathComponent only works with file paths (not, for example, string representations of URLs).
    // Parameters --->   aString: the path component to append to the receiver.
    // Returns ---> a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    
    
    NSLog(@"DB Path: %@", _dbPathString);
    
    NSFileManager *fileManager = [NSFileManager defaultManager]; //declaring filemanager which we can refer to when we want to access the file system
    
    //NSFileManager class enables you to perform many generic file-system operations and insulates an app from the underlying file system
    
    if (![fileManager fileExistsAtPath:_dbPathString]){ //fileExistsAtPath is a method on fileManager, with dbPathString as the argument
        NSLog(@"Data File does not exist");
        //simulator can read from desktop since it runs in the computer, but iphone can't access computer folders
        
        //The next three lines are for actually creating the db
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"telecom" ofType:@"db"];

        //An NSBundle object represents a location in the file system that groups code and resources that can be used in a program.
        // mainBundle: Returns the NSBundle object that corresponds to the directory where the current application executable is located.
        //pathForResource: returns the full pathname for the resource identified by the specified name and file extension.
        
        NSLog(@"Resource Path: %@", resourcePath);
        
        
        [fileManager copyItemAtPath:resourcePath toPath:_dbPathString error:nil];
        
        //Copies the item at the specified path to a new location synchronously.
        
    }
    else{
        NSLog(@"Data File exist");
    }

    
    
}


-(NSMutableArray *)readCompanyDataFromDB {
    
    NSLog(@"readCompanyDataFromDB");
    
    NSMutableArray *companyList = [[NSMutableArray alloc] init];
    //allocate and initialize the company list array here
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([_dbPathString UTF8String], &companyDB)==SQLITE_OK){
        
    NSLog(@"sqlite3_open"); //to verify sqlite3 opened the file correctly
        
   //opening the file at dbPath and its returning the response code, SQLITE_OK returns 0 since its status code
        
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM company"];
        
    const char *query_sql = [querySQL UTF8String]; //converting to type of string C understands
        
        if (sqlite3_prepare(companyDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            
    while (sqlite3_step(statement)== SQLITE_ROW){ //while stepping through database, if it returns a row it should keep going, cuts out if it returns something other than SQLITE_ROW
        
        NSString *companyID = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
        NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
        NSString *stockSymbol = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
        NSString *stockPrice = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
        NSString *logo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
    
        Company *company = [[Company alloc]init];
        company.companyID = companyID;
        company.name = name;
        company.logo = logo;
        company.stockSymbol = stockSymbol;
        company.stockPrice = stockPrice;

        //confirm everything works by invoking print method
        
        [company print];
        
        [companyList addObject:company];
    
    }
    
    //close db
        }
            sqlite3_close(companyDB);
            
    }
    
        for (Company* company in companyList) {
            
        NSMutableArray *productList = [self readProductDataFromDBForCompanyID:company.companyID];
  
 
            company.products = productList;
            

        }
        
        
        return companyList;
}
    
-(NSMutableArray*) readProductDataFromDBForCompanyID:(NSString*)companyId {
        
    NSMutableArray *productList = [[NSMutableArray alloc] init];
    
    
    sqlite3_stmt *statement;
        
    if (sqlite3_open([_dbPathString UTF8String], &companyDB)==SQLITE_OK){

        NSString *querySQL = [NSString stringWithFormat:@"select * from product where productid = %@", companyId];

        const char *query_sql = [querySQL UTF8String]; //converting to type of string C understands
        
        if (sqlite3_prepare(companyDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {

            while (sqlite3_step(statement)== SQLITE_ROW) //while stepping through database, if it returns a row it should keep going, cuts out if it returns something other than SQLITE_ROW
            {
        
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *website = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *productID = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                
                Product *product = [[Product alloc]init];
                product.productID = productID;
                product.name = name;
                product.website = website;
                
                [product print];
                
                [productList addObject:product];
  
                
            }
            
            }
        
        
        sqlite3_close(companyDB);
        
        
    }
    
    
    return productList;
    
    
}
    
    
-(void) deleteProductFromDB:(NSString*)productname; {
    
    if (sqlite3_open([_dbPathString UTF8String], &companyDB)==SQLITE_OK){
    
        NSLog(@"sqlite_3 is open");
        
        
        NSString *querySQL = [NSString stringWithFormat:@"delete from product where productname = '%@'", productname];

        NSLog(@"Product Delete SQL: %@", querySQL);

        
        const char *deleteQuery = [querySQL UTF8String]; //converting to type of string C understands
        
        if (sqlite3_exec(companyDB, deleteQuery, NULL, NULL, nil)==SQLITE_OK)
        {
            NSLog(@"Product Deleted");
        }
        
        sqlite3_close(companyDB);
    }
  
        
    
    
}


    
    
@end