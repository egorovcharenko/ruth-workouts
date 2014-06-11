//
//  Tip.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 12.06.14.
//  Copyright (c) 2014 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tip : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * text;

@end
