//
//  Section.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutVariant;

@interface Section : NSManagedObject

@property (nonatomic) int16_t length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *childActivities;
@property (nonatomic, retain) WorkoutVariant *parentVariant;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addChildActivitiesObject:(NSManagedObject *)value;
- (void)removeChildActivitiesObject:(NSManagedObject *)value;
- (void)addChildActivities:(NSSet *)values;
- (void)removeChildActivities:(NSSet *)values;

@end
