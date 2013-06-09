//
//  Tip.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 08.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tip : NSManagedObject

@property (nonatomic) int16_t number;
@property (nonatomic, retain) NSString * text;

@end
