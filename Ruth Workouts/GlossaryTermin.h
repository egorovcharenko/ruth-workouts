//
//  GlossaryTermin.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GlossaryTopic;

@interface GlossaryTermin : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) GlossaryTopic *parentTopic;

@end
