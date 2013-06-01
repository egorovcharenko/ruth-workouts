//
//  SectionActivity.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 01.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
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
@property (nonatomic, retain) Section *parentSection;

@end
