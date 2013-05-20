//
//  Performance.h
//  myEDC
//
//  Created by Scott Delly on 6/20/11.
//  Copyright (c) 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Day, Stage;

@interface Performance : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSString * stopTimeString;
@property (nonatomic, retain) NSNumber * conflict;
@property (nonatomic, retain) NSNumber * stopTime;
@property (nonatomic, retain) NSNumber * performanceID;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) NSString * startTimeString;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) Day * day;
@property (nonatomic, retain) Artist * artist;
@property (nonatomic, retain) Stage * stage;

@end
