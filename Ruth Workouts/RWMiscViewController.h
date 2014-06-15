//
//  RWMiscViewController.h
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 09.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RWMiscViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)rateButtonClicked:(id)sender;
- (IBAction)sendFeedbackButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
