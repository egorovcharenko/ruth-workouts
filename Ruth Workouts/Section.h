//
//  Section.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SectionActivity, WorkoutVariant;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *childActivities;
@property (nonatomic, retain) WorkoutVariant *parentVariant;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addChildActivitiesObject:(SectionActivity *)value;
- (void)removeChildActivitiesObject:(SectionActivity *)value;
- (void)addChildActivities:(NSSet *)values;
- (void)removeChildActivities:(NSSet *)values;

@end
