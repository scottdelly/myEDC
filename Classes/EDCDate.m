//
//  EDCDate.m
//  myEDC
//
//  Created by Scott Delly on 6/7/10.
//  Copyright 2010 Scott Delly. All rights reserved.
//

#import "EDCDate.h"


@implementation EDCDate

+(double)edcStartTimeIntervalSince1970{
	return EDC_START_TIME;
}

+(double)edcEndTimeIntervalSince1970{
	return EDC_START_TIME+129600;
}

+(double)twoHoursBeforeEDCStartTimeIntervalSince1970{
	return EDC_START_TIME-7200;
}

+(double)endEDCDayOneIntervalSince1970{
	return EDC_START_TIME+43200;
}

+(double)currentTimeIntervalSince1970{
	double time = [[NSDate date] timeIntervalSince1970];//+968400
	/*
	NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:time];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE h:mm a"];
	NSString *formattedDate = [dateFormatter stringFromDate:tmpDate];
	
	NSLog(@"The current time is: %f, %@", time, formattedDate);
	 */
	//return time;
    return 1277492401;
}
	
+(NSDictionary *)differenceBetweenTimeIntervalsSince1970WithStartTime:(double)startTime andEndTime:(double)endTime{
	int secondsInADay = 86400;
	int secondsInAnHour = 3600;
	int secondsInAMinute = 60;
	
	double timeToLive = endTime - startTime;
	
	NSNumber *days = [NSNumber numberWithInt:(timeToLive/secondsInADay)];
	timeToLive-=[days intValue]*secondsInADay;
	NSNumber *hours = [NSNumber numberWithInt:(timeToLive/secondsInAnHour)];
	timeToLive-=[hours intValue]*secondsInAnHour;
	NSNumber *minutes = [NSNumber numberWithInt:(timeToLive/secondsInAMinute)];
	timeToLive-=[minutes intValue]*secondsInAMinute;
	NSNumber *seconds = [NSNumber numberWithInt:timeToLive];
	
	NSDictionary *timeObjects = [NSDictionary dictionaryWithObjectsAndKeys:days,@"days",hours,@"hours",minutes,@"minutes",seconds,@"seconds",nil];
	
	return timeObjects;
}

+(int)dayNumberFromIntervalSince1970:(double)interval{
	if (interval < [self endEDCDayOneIntervalSince1970]) {
		return 0;
	}
	return 1;
}

@end
