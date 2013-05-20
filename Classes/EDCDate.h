//
//  EDCDate.h
//  myEDC
//
//  Created by Scott Delly on 6/7/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EDC_START_TIME 1277492400//1308938400
/*
 GMT: Fri, 25 Jun 2010 21:00:00 GMT
 Your timezone: Fri Jun 25 2010 14:00:00 GMT-0700 (PDT)
 */

@interface EDCDate : NSObject {
	
}

+(double)edcStartTimeIntervalSince1970;
+(double)edcEndTimeIntervalSince1970;
+(double)twoHoursBeforeEDCStartTimeIntervalSince1970;
+(double)endEDCDayOneIntervalSince1970;

+(double)currentTimeIntervalSince1970;

+(NSDictionary *)differenceBetweenTimeIntervalsSince1970WithStartTime:(double)startTime andEndTime:(double)endTime;

+(int)dayNumberFromIntervalSince1970:(double)interval;

@end