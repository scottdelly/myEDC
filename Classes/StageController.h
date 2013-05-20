//
//  StageController.h
//  myEDC
//
//  Created by Scott Delly on 6/10/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myEDCAppDelegate.h"
#import "EDCDate.h"
#import "StageConstants.h"
#import "Stage.h"
@class Stage;

@interface StageController : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSEntityDescription *entity;
	NSError *error;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSError *error;

- (void) addStage:(NSDictionary *)newStageDictionary;
- (void) deleteStage:(Stage *)oldStage;

- (NSMutableArray *) fetchStagesWithSort:(NSArray *)newSort andPredicate:(NSPredicate *)newPredicate andLimit:(int)newLimit;
- (int) numberOfStages;

@end
