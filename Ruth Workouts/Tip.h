//
//  Tip.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 18.05.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tip : NSManagedObject

@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSString * text;

@end
