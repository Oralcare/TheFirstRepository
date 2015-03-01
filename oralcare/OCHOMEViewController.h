//
//  OCHOMEViewController.h
//  oralcare
//
//  Created by mhand on 15/3/1.
//  Copyright (c) 2015年 Hangzhou Oralcare Technical Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCHOMEViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
