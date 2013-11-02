//
//  HTPushViewController.h
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-30.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNavigationController.h"

#define HTNavigationBarWidth  320.0f
#define HTNavigationBarHeight 44.0f
#define HTNavigationBarTitleSize  18.0f
#define HTNavigationBarLeftMargin 15.0f
#define HTNavigationBarRightMargin 15.0f


@class HTNavigationBar;
@class HTNavigationController;
@class HTNavigationItem;

@interface HTPushViewController : UIViewController

@property (nonatomic, retain)   HTNavigationBar *navigationBar;
@property (nonatomic, retain)   UIView *maskView;

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

@property (nonatomic, assign)   HTNavigationBar *htNavigationBar;

@end

@interface UIViewController (HTNavigationPush)

@property (nonatomic, retain)   HTNavigationController *navigationController;
@property (nonatomic, retain)   HTNavigationItem  *navigationItem;

@end
