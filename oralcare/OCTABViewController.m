//
//  OCTABViewController.m
//  oralcare
//
//  Created by mhand on 15/3/1.
//  Copyright (c) 2015年 Hangzhou Oralcare Technical Co.,Ltd. All rights reserved.
//

#import "OCTABViewController.h"
#define KSCREEM_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define KSCREEM_WIDTH      [UIScreen mainScreen].bounds.size.width
@interface OCTABViewController ()

@end

@implementation OCTABViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    隐藏原来的tabbat
    self.tabBar.hidden=YES;
    [self initTabbarView];
    // Do any additional setup after loading the view.
}
//创建自定义的tabbar
-(void)initTabbarView{
    
    self.tabView=[[UIView alloc]initWithFrame:CGRectMake(0,KSCREEM_HEIGHT-49,KSCREEM_WIDTH, 49)];
    self.tabView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:self.tabView];
       for (int i=0; i<5; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
           
        button.frame=CGRectMake(i*75, 0, 75, 49);
        button.tag=i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabView addSubview:button];
    }
}
-(void)selectedTab:(UIButton *)sender{
    
    self.selectedIndex=sender.tag;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
