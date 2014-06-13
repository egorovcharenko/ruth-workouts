//
//  SectionActivity.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface SectionActivity : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * len;
@property (nonatomic, retain) NSString * lenDetails;
@property (nonatomic, retain) NSNumber * lenMultiplier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) Section *parentSection;

@end
