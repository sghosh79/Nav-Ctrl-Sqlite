//
//  Product.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/18/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *website;

@property (nonatomic, retain) NSString *productID;


+(id)initWithName:(NSString *)name website:(NSString *)website productID: (NSString *)productID;

-(void)print;



@end
    