//
//  Section.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SectionActivity, WorkoutVariant;

@interface Section : NSManagedObject

@property (nonatomic) int16_t length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) NSSet *childActivities;
@property (nonatomic, retain) WorkoutVariant *parentVariant;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addChildActivitiesObject:(SectionActivity *)value;
- (void)removeChildActivitiesObject:(SectionActivity *)value;
- (void)addChildActivities:(NSSet *)values;
- (void)removeChildActivities:(NSSet *)values;

@end
