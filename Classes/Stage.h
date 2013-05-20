//
//  Stage.h
//  myEDC
//
//  Created by Scott Delly on 6/20/11.
//  Copyright (c) 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Performance;

@interface Stage : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSNumber * stageID;
@property (nonatomic, retain) NSSet* performances;

@end
