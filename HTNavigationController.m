//
//  HTNavigationController.m
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTNavigationController.h"

@interface HTNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation HTNavigationController

- (id)initWithRootViewController:(HTPushViewController *)viewController
{
    self = [super init];
    if (self) {
        [self pushViewController:viewController animated:NO];
        self.rootViewController = viewController;
    }
    return self;
}

- (void)pushViewController:(HTPushViewController *)showViewController animated:(BOOL)animated
{
    showViewController.navigationItem.htNavigationBar = showViewController.navigationBar;

    //你注掉这段代码会崩的，找到原因还望告我一下啊。QQ：82314193
    showViewController.view = showViewController.view;
    
    HTPushViewController *hideViewController = [self.viewControllers lastObject];
    self.topViewController = showViewController;
    [self.viewControllers addObject:showViewController];
    showViewController.navigationController = self;
    
    [self initViewController:showViewController];


    UIView *hideView = hideViewController.view;
    UIView *showView = showViewController.view;
    
    [hideView addSubview:hideViewController.maskView];
    
    CGRect  rect    = self.view.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat width   = CGRectGetWidth(rect);
    CGFloat locationY = ISIOS7 ? 0 : 0;
    showView.frame = CGRectMake(HTNavigationBarWidth, locationY, width, height);
    [self.view addSubview:showView];
    
    [UIView animateWithDuration:animated ? .5f : 0 animations:^{
        showView.frame = CGRectMake(0, locationY, width, height);
        hideView.transform = CGAffineTransformMakeScale(.9, .9);
        hideViewController.maskView.alpha = .6f;
    } completion:^(BOOL finished) {
        hideView.transform = CGAffineTransformIdentity;
        [hideView removeFromSuperview];

    }];

    
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    [self popToViewController:[self getLastViewController] animated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    [self popToViewController:self.rootViewController animated:animated];
}

- (void)popToViewController:(HTPushViewController *)viewController animated:(BOOL)animated
{
    UIView *showView = viewController.view;
    UIView *hideView = ((UIViewController *)[self.viewControllers lastObject]).view;
    [self.view insertSubview:showView belowSubview:hideView];
    showView.transform = CGAffineTransformMakeScale(.9f, .9f);
    
    CGRect  rect    = self.view.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat width   = CGRectGetWidth(rect);
    
    [UIView animateWithDuration:animated ? .5f : 0 animations:^{
        showView.transform = CGAffineTransformIdentity;
        viewController.maskView.alpha = .0f;
        hideView.frame = CGRectMake(HTNavigationBarWidth, 0, width, height);
        
    } completion:^(BOOL finished) {
        [hideView removeFromSuperview];
        [viewController.maskView removeFromSuperview];
        NSInteger location = [self.viewControllers indexOfObject:viewController];
        NSArray *leftControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, location + 1)];
        self.viewControllers = [NSMutableArray arrayWithArray:leftControllers];
        self.topViewController = viewController;
    }];
}

- (void)initViewController:(HTPushViewController *)viewController
{
    [self initNavigationItem:viewController];
    [self addNavigationBarToViewController:viewController];
    
    UILabel *titleLabel  = (UILabel *)viewController.navigationBar.titleView;
    titleLabel.text = viewController.title;
    
    if (self.viewControllers.count > 1) {
        [self addSwipeGesture:viewController];
        [self addPanGesture:viewController];
    }
    
}

- (HTPushViewController *)getLastViewController
{
    NSInteger count = [self.viewControllers count];
    if (count - 2 >= 0) {
        return [self.viewControllers objectAtIndex:count - 2];
    }
    return Nil;
}

- (void)addPanGesture:(UIViewController *)viewController
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [viewController.view addGestureRecognizer:pan];
    pan.delegate = self;
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    static CGPoint startPoint;
    static CGPoint movepoint;
    static CGPoint endPoint;
    NSInteger length;
    
    HTPushViewController *showViewController = [self getLastViewController];
    UIView *showView = showViewController.view;
    UIView *hideView = self.topViewController.view;
    CGRect rect = hideView.frame;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.view insertSubview:showView belowSubview:hideView];
        showView.transform = CGAffineTransformMakeScale(.9, .9);
        startPoint = [recognizer locationInView:self.view];
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        movepoint = [recognizer locationInView:self.view];
        length = movepoint.x - startPoint.x;
        
        if (length > 0 && length < 130) {
            rect.origin.x = length;
            hideView.frame = rect;
            CGFloat persentX = movepoint.x / HTNavigationBarWidth;
            CGFloat persent = .1 * persentX + .9;
            showView.transform = CGAffineTransformMakeScale(persent, persent);
            showViewController.maskView.alpha = 0.6 - 0.6 * persentX;
        }else if (length > 130.0f){
            recognizer.enabled = NO;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded ||
              recognizer.state == UIGestureRecognizerStateCancelled) {
        
        endPoint = [recognizer locationInView:self.view];
        length = endPoint.x - startPoint.x;
        
        if (length < 100) {
            [self leftMoveAnimation:self.topViewController showView:showViewController];
            
        }else {
            [self rightMoveAnimation:self.topViewController showView:showViewController];
            
            NSInteger location = [self.viewControllers indexOfObject:showViewController];
            NSArray *leftControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, location + 1)];
            self.viewControllers = [NSMutableArray arrayWithArray:leftControllers];
            self.topViewController = showViewController;
        }
        
    }
    
}

- (void)leftMoveAnimation:(HTPushViewController *)hideViewController showView:(HTPushViewController *)showViewController
{
    UIView *hideView = hideViewController.view;
    UIView *showView = showViewController.view;
    
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        CGRect rect = hideView.frame;
        rect.origin.x = 0.0f;
        hideView.frame = rect;
        showView.transform = CGAffineTransformMakeScale(.9, .9);
        showViewController.maskView.alpha = .6f;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

- (void)rightMoveAnimation:(HTPushViewController *)hideViewController showView:(HTPushViewController *)showViewController
{
    UIView *hideView = hideViewController.view;
    UIView *showView = showViewController.view;
    
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        CGRect rect = hideView.frame;
        rect.origin.x = 320.0f;
        hideView.frame = rect;
        showView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        showViewController.maskView.alpha = .0f;
} completion:^(BOOL finished) {
        [showViewController.maskView removeFromSuperview];
        [hideView removeFromSuperview];
}];

    
}

- (void)addSwipeGesture:(UIViewController *)viewController
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureReconizer:)];
    [viewController.view addGestureRecognizer:swipe];
}

- (void)swipeGestureReconizer:(UISwipeGestureRecognizer *)recognizer
{
    if (self.viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    }
}

- (void)initNavigationItem:(HTPushViewController *)viewController
{
    HTNavigationItem *navItem = [viewController navigationItem];
    navItem.htNavigationBar = viewController.navigationBar;
    if (self.viewControllers.count > 1) {
        navItem.leftBarButtonItem = [self backBarButtonItem];
    }
    
}

- (UIBarButtonItem *)backBarButtonItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 43, 30);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateHighlighted];
    [backButton setBackgroundImage:[UIImage imageNamed:@"banner_button"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"banner_button"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return barItem;
}

- (void)backBarButtonClicked:(UIBarButtonItem *)barItem
{
    [self popViewControllerAnimated:YES];
}

- (void)addNavigationBarToViewController:(HTPushViewController *)viewController
{
//    NSLog(@"%@ \n: %@", viewController, viewController.navigationBar);
    [viewController.view addSubview:viewController.navigationBar];
}

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


