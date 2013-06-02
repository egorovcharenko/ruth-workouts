//
//  Glossary.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 02.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Glossary : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * termin;

@end
