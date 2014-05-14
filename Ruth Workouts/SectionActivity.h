//
//  SectionActivity.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 14.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface SectionActivity : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic) int16_t len;
@property (nonatomic, retain) NSString * lenDetails;
@property (nonatomic) int16_t lenMultiplier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) Section *parentSection;

@end
