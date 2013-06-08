//
//  RWCompleteWorkoutViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 08.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWCompleteWorkoutViewController.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "Workout.h"
#import "WorkoutVariant.h"


@interface RWCompleteWorkoutViewController ()

@end

@implementation RWCompleteWorkoutViewController

@synthesize variant;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
}

#pragma mark - Share

- (void)sharingStatus {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSLog(@"FB service available");
        self.shareFBButton.enabled = YES;
        self.shareFBButton.alpha = 1.0f;
    } else {
        self.shareFBButton.enabled = NO;
        self.shareFBButton.alpha = 0.5f;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSLog(@"Twitter service available");
        self.shareTwitterButton.enabled = YES;
        self.shareTwitterButton.alpha = 1.0f;
    } else {
        self.shareTwitterButton.enabled = NO;
        self.shareTwitterButton.alpha = 0.5f;
    }
}

- (IBAction)shareTwitterButtonClicked:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:[self getText]];
        
        //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (NSString*) getText
{
    return [NSString stringWithFormat:@"I have completed workout #%d in Ruth Workouts! The total length was %d", variant.parentWorkout.number, variant.length];
}

- (IBAction)shareFacebookButtonClicked:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:[self getText]];
        
        //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}
@end
