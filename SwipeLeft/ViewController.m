//
//  ViewController.m
//  SwipeLeft
//
//  Created by Visnu on 4/10/14.
//  Copyright (c) 2014 Visnu Pitiyanuvath. All rights reserved.
//

#import "ViewController.h"
#import "SlideAnimatedTransitioning.h"

@interface ViewController ()

@property UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer;
@property UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePanGesture:)];
  self.edgePanGestureRecognizer.edges = UIRectEdgeRight;
  [self.view addGestureRecognizer:self.edgePanGestureRecognizer];
}

- (void)handleScreenEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
  CGFloat width = self.view.frame.size.width,
          percent = MAX(-[sender translationInView:self.view].x, 0) / width,
          velocity = 0;

  switch (sender.state) {
    case UIGestureRecognizerStatePossible:
      break;
    case UIGestureRecognizerStateBegan:
      self.navigationController.delegate = self;
      [self performSegueWithIdentifier:@"next" sender:sender];
      break;
    case UIGestureRecognizerStateChanged:
      [self.percentDrivenInteractiveTransition updateInteractiveTransition:percent];
      break;
    case UIGestureRecognizerStateEnded:
      velocity = [sender velocityInView:self.view].x;
      if (velocity < 0 && (percent > 0.5 || velocity < -1000))
        [self.percentDrivenInteractiveTransition finishInteractiveTransition];
      else
        [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
      break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateFailed:
      [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
      break;
  }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
  return [SlideAnimatedTransitioning new];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
  self.navigationController.delegate = nil;

  if (self.edgePanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
    self.percentDrivenInteractiveTransition = [UIPercentDrivenInteractiveTransition new];
    self.percentDrivenInteractiveTransition.completionCurve = UIViewAnimationOptionCurveEaseOut;
  } else {
    self.percentDrivenInteractiveTransition = nil;
  }

  return self.percentDrivenInteractiveTransition;
}

@end
