//
//  Artist.h
//  myEDC
//
//  Created by Scott Delly on 1/26/12.
//  Copyright (c) 2012 Vander-Bend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Performance;

@interface Artist : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * listenURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * artistID;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * updated;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSSet* performances;

@end
