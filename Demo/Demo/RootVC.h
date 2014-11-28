//
//  RootVC.h
//  Demo
//
//  Created by PFei_He on 14-11-28.
//  Copyright (c) 2014年 PF-Lib. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCarouselView.h"

@interface RootVC : UIViewController <PFCarouselViewDelegate>
{
    NSMutableArray  *viewsArray;    //视图数组

    NSArray         *textArray;     //文本数组
}

@end
