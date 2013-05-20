//
//  Version.h
//  myEDC
//
//  Created by Scott Delly on 6/20/11.
//  Copyright (c) 2011 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Version : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * performancesVersion;
@property (nonatomic, retain) NSNumber * stagesVersion;
@property (nonatomic, retain) NSNumber * artistsVersion;
@property (nonatomic, retain) NSNumber * daysVersion;

@end
