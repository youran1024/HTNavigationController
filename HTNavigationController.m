//
//  HTNavigationController.m
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTNavigationController.h"
#import "UIViewController+HTNavigationPush.h"
#import <QuartzCore/QuartzCore.h>

@interface HTNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation HTNavigationController

- (id)initWithRootViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        [self pushViewController:viewController animated:NO];
        self.rootViewController = viewController;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)showViewController animated:(BOOL)animated
{
    UIViewController *hideViewController = [self.viewControllers lastObject];
    self.topViewController = showViewController;
    [self.viewControllers addObject:showViewController];
    
    showViewController.navigationController = self;

    [self initViewController:showViewController];

    UIView *hideView = hideViewController.view;
    UIView *showView = showViewController.view;
    
    CGRect  rect    = self.view.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat width   = CGRectGetWidth(rect);
    
    showView.frame = CGRectMake(320, 0, width, height);
    [self.view addSubview:showView];
    
    [UIView animateWithDuration:animated ? .5 : 0 animations:^{
        showView.frame = CGRectMake(0, 0, width, height);
        hideView.transform = CGAffineTransformMakeScale(.9, .9);
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

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIView *showView = viewController.view;
    UIView *hideView = ((UIViewController *)[self.viewControllers lastObject]).view;
    [self.view insertSubview:showView belowSubview:hideView];
    showView.transform = CGAffineTransformMakeScale(.9, .9);
    
    CGRect  rect    = self.view.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat width   = CGRectGetWidth(rect);
    
    [UIView animateWithDuration:animated ? .5 : 0 animations:^{
        showView.transform = CGAffineTransformIdentity;
        hideView.frame = CGRectMake(320, 0, width, height);
    } completion:^(BOOL finished) {
        [hideView removeFromSuperview];
        NSInteger location = [self.viewControllers indexOfObject:viewController];
        NSArray *leftControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, location + 1)];
        self.viewControllers = [NSMutableArray arrayWithArray:leftControllers];
        self.topViewController = viewController;
    }];
}

- (void)initViewController:(UIViewController *)viewController
{
    
    [self addNavigationBarToViewController:viewController];
    [self initNavigationItem:viewController];
    if (self.viewControllers.count > 1) {
        [self addSwipeGesture:viewController];
        [self addPanGesture:viewController];
    }
    
}

- (UIViewController *)getLastViewController
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
    
    UIViewController *showViewController = [self getLastViewController];
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
            CGFloat persent = .1 * movepoint.x / 320 + .9;
            showView.transform = CGAffineTransformMakeScale(persent, persent);
        }else if (length > 130.0f){
            recognizer.enabled = NO;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded ||
              recognizer.state == UIGestureRecognizerStateCancelled) {
        
        endPoint = [recognizer locationInView:self.view];
        length = endPoint.x - startPoint.x;
        
        if (length < 100) {
            [self leftMoveAnimation:hideView showView:showView];
            
        }else {
            [self rightMoveAnimation:hideView showView:showView];
            
            NSInteger location = [self.viewControllers indexOfObject:showViewController];
            NSArray *leftControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, location + 1)];
            self.viewControllers = [NSMutableArray arrayWithArray:leftControllers];
            self.topViewController = showViewController;
        }
        
    }
    
}

- (void)leftMoveAnimation:(UIView *)hideView showView:(UIView *)showView
{
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        CGRect rect = hideView.frame;
        rect.origin.x = 0.0f;
        hideView.frame = rect;
        showView.transform = CGAffineTransformMakeScale(.9, .9);
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

- (void)rightMoveAnimation:(UIView *)hideView showView:(UIView *)showView
{
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        CGRect rect = hideView.frame;
        rect.origin.x = 320.0f;
        hideView.frame = rect;
        showView.transform = CGAffineTransformMakeScale(1.0, 1.0);
} completion:^(BOOL finished) {
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

- (void)initNavigationItem:(UIViewController *)viewController
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

- (void)addNavigationBarToViewController:(UIViewController *)viewController
{
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

@implementation HTNavigationBar

- (void)setRightView:(UIView *)rightView
{
    if (_rightView != rightView) {
        [_rightView removeFromSuperview];
        _rightView = rightView;
        [self addSubview:_rightView];
        [self setNeedsDisplay];
    }
}

- (void)setLeftView:(UIView *)leftView
{
    if (_leftView != leftView) {
        [_leftView removeFromSuperview];
        _leftView = leftView;
        [self addSubview:_leftView];
        [self setNeedsDisplay];
    }
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self addSubview:_titleView];
        [self setNeedsDisplay];
    }
    return _titleView;
}

- (UILabel *)titleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.font = [UIFont systemFontOfSize:14.0f];
    return label;
}

- (void)setTitleView:(UIView *)titleView
{
    if (_titleView != titleView) {
        [_titleView removeFromSuperview];
        [self addSubview:titleView];
        _titleView = titleView;
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews
{
    CGRect rect     = self.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat originY;
    if (_leftView) {
        originY = (height - CGRectGetHeight(_leftView.frame)) / 2;
        rect = _leftView.frame;
        rect.origin.x = 20.f;
        rect.origin.y = originY;
        _leftView.frame = rect;
    }
    
    if (_titleView) {
        
    }
    if (_rightView) {
        originY = (height - CGRectGetHeight(_rightView.frame)) / 2;
        rect = _rightView.frame;
        rect.origin.x = 320 - 20 - CGRectGetWidth(rect);
        rect.origin.y = originY;
        _rightView.frame = rect;
    }
    
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"banner.png"] drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    float centerX = rect.size.width / 2;
    float centerY = rect.size.height / 2;
    float width = rect.size.width;
    float radius = 7;
    CGContextMoveToPoint(context, 0, centerY);
    CGContextAddArcToPoint(context, 0, 0, centerX, 0, radius);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, width, centerY);
    CGContextAddArcToPoint(context, width, 0, centerX, 0, radius);
    CGContextAddLineToPoint(context, width, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);

}
@end

@implementation HTNavigationItem

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self.htNavigationBar setLeftView:leftBarButtonItem.customView];
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self.htNavigationBar setRightView:rightBarButtonItem.customView];
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    
}


@end
