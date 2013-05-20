//
//  VersionController.h
//  myEDC
//
//  Created by Scott Delly on 6/15/11.
//  Copyright 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myEDCAppDelegate.h"
#import "VersionConstants.h"


@interface VersionController : NSObject {
    NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entity;
	NSError *error;  
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;

-(BOOL)isNewer:(NSDictionary *) newVersionDictionary;
-(void)updateVersions:(NSDictionary *)newVersionDictionary;
-(NSMutableArray *) fetchVersions;

@end