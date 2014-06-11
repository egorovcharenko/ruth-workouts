//
//  Category.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plan;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * hideInList;
@property (nonatomic, retain) NSSet *childPlans;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addChildPlansObject:(Plan *)value;
- (void)removeChildPlansObject:(Plan *)value;
- (void)addChildPlans:(NSSet *)values;
- (void)removeChildPlans:(NSSet *)values;

@end
