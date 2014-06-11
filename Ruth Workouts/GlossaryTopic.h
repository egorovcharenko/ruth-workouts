//
//  GlossaryTopic.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GlossaryTermin;

@interface GlossaryTopic : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *topicTermins;
@end

@interface GlossaryTopic (CoreDataGeneratedAccessors)

- (void)addTopicTerminsObject:(GlossaryTermin *)value;
- (void)removeTopicTerminsObject:(GlossaryTermin *)value;
- (void)addTopicTermins:(NSSet *)values;
- (void)removeTopicTermins:(NSSet *)values;

@end
