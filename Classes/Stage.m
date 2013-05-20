//
//  Stage.m
//  myEDC
//
//  Created by Scott Delly on 6/20/11.
//  Copyright (c) 2011 Scott Delly. All rights reserved.
//

#import "Stage.h"
#import "Performance.h"


@implementation Stage
@dynamic name;
@dynamic updated;
@dynamic stageID;
@dynamic performances;

- (void)addPerformancesObject:(Performance *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"performances" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"performances"] addObject:value];
    [self didChangeValueForKey:@"performances" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePerformancesObject:(Performance *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"performances" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"performances"] removeObject:value];
    [self didChangeValueForKey:@"performances" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPerformances:(NSSet *)value {    
    [self willChangeValueForKey:@"performances" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"performances"] unionSet:value];
    [self didChangeValueForKey:@"performances" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePerformances:(NSSet *)value {
    [self willChangeValueForKey:@"performances" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"performances"] minusSet:value];
    [self didChangeValueForKey:@"performances" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
