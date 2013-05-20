//
//  Day.h
//  myEDC
//
//  Created by Scott Delly on 1/26/12.
//  Copyright (c) 2012 Vander-Bend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Performance;

@interface Day : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * dayID;
@property (nonatomic, retain) NSNumber * stopTime;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSSet* performances;

@end
