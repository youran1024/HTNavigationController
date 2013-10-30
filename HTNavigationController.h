//
//  HTNavigationController.h
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTNavigationController : UIViewController

@property (nonatomic, strong)   UIViewController *topViewController;
@property (nonatomic, strong)   NSMutableArray *viewControllers;
@property (nonatomic, strong)   UIViewController *rootViewController;
//@property (nonatomic, strong)   UINavigationBar *navigationBar;

- (id)initWithRootViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

@interface HTNavigationBar : UIView
{
    UIView *_titleView;

}
@property (nonatomic, strong)   UIView *leftView;
@property (nonatomic, strong)   UIView *rightView;
@property (nonatomic, strong)   UIView *titleView;

@end

@interface HTNavigationItem : UINavigationItem

@property (nonatomic, strong)   HTNavigationBar *htNavigationBar;

@end