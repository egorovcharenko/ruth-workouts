//
//  GlossaryTermin.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 09.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GlossaryTopic;

@interface GlossaryTermin : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) GlossaryTopic *parentTopic;

@end
