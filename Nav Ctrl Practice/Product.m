//
//  Product.m
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/18/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import "Product.h"

@implementation Product

+(id)initWithName:(NSString *)name website:(NSString *)website productID: (NSString *)productID

{
    
    
    Product *product = [[Product alloc] init];
    
    if(product) {
        
        product.name = name;
        product.website = website;
        product.productID = productID;
        
    }
    
    return product;
}


-(void)print{
    
    //break up the string with %@ and comma where you want the variables to show up
    
    NSLog(@"ProductName:%@, Product Website:%@, Product ID:%@", self.name, self.website, self.productID);
    
    
    
}


@end
