//
//  RootVC.h
//  PFCarouselView
//
//  Created by PFei_He on 14-10-24.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCarouselView.h"

@interface RootVC : UIViewController <PFCarouselViewDelegate>
{
    NSMutableArray  *viewsArray;    //视图数组

    NSArray         *textArray;     //文本数组
}

@end
