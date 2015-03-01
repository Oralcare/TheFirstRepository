//
//  OCHOMEViewController.m
//  oralcare
//
//  Created by mhand on 15/3/1.
//  Copyright (c) 2015年 Hangzhou Oralcare Technical Co.,Ltd. All rights reserved.
//

#import "OCHOMEViewController.h"
#import "OCATTableViewCell.h"
#import "MJRefresh.h"
#define KSCREEM_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define KSCREEM_WIDTH      [UIScreen mainScreen].bounds.size.width
#define KLeft 0
#define kRight 1
#define KREGRESH 0
#define KADD 1
@interface OCHOMEViewController ()

@end

@implementation OCHOMEViewController{
//    存放图片的数组
    NSMutableArray *adImageArray;
//    行数
    UIScrollView *adImageScrollV;
    
    
    UIVisualEffectView *LightCView;
    int cellCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  行数的初始值
    cellCount=10;
//    展示假数据
    [self getDataFromServeRefreshOrAdd:KREGRESH];
    
// 添加广告滚动视图上去
    [self initAdView];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    添加上拉刷新 下拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(headerrefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerrefresh)];
    
    
}

-(void)headerrefresh{
    //数据传好
    [self getDataFromServeRefreshOrAdd:KREGRESH];
    
    
    
}

-(void)footerrefresh{
    
    [self getDataFromServeRefreshOrAdd:KADD];
    
    //加载数据
}


-(void)getDataFromServeRefreshOrAdd:(BOOL)rorf{
// 从服务器获取的数据 这里假数据填充
       adImageArray= [NSMutableArray arrayWithCapacity:3];
    UIImage *fimage=[UIImage imageNamed:@"1.jpg"];
    UIImage *simage=[UIImage imageNamed:@"2.jpg"];
    UIImage *timage=[UIImage imageNamed:@"3.jpg"];

    
    [adImageArray addObject:fimage];
    [adImageArray addObject:simage];
    [adImageArray addObject:timage];
    if (rorf==KREGRESH) {
       cellCount=10;
    }
    else if (rorf==KADD){
        cellCount+=10;
    }

    [self completeReload];
  }
-(void)completeReload{
//    结束刷新效果
    [self.tableView reloadData];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}

-(void)initAdView{
//    添加广告视图
    UIView *AdView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,KSCREEM_WIDTH, 250)];
    AdView.backgroundColor=[UIColor  groupTableViewBackgroundColor];
    
    UITextField  *searchField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, KSCREEM_WIDTH-20, 30)];
    searchField.backgroundColor=[UIColor whiteColor];
    searchField.delegate=self;
    searchField.tag=666;
    adImageScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,KSCREEM_WIDTH, 200)];
    [adImageScrollV setContentSize:CGSizeMake(KSCREEM_WIDTH*[adImageArray count],200)];
    UIPageControl *pageC;
    
    pageC=[[UIPageControl alloc]initWithFrame:CGRectMake(160,215, 50, 30)];
    pageC.tag=555;
    
    pageC.numberOfPages=[adImageArray count];
    [self.tableView addSubview:pageC];

    for (int index=0; index<[adImageArray count]; index++){
        UIImageView *imageV;
        if ([adImageScrollV viewWithTag:1001+index]==nil) {
            
            imageV=[[UIImageView  alloc]initWithFrame:CGRectMake(KSCREEM_WIDTH*index, 0, KSCREEM_WIDTH, 200)];
            imageV.tag=1001+index;
            [adImageScrollV addSubview:imageV];
            
     }

        imageV=(UIImageView *)[adImageScrollV viewWithTag:1001+index];
        
        imageV.image=[adImageArray objectAtIndex:index];

       }
    [AdView addSubview:searchField];
    [AdView addSubview:adImageScrollV];
    adImageScrollV.pagingEnabled=YES;
    adImageScrollV.scrollEnabled=YES;
    adImageScrollV.delegate=self;
    self.tableView.tableHeaderView=AdView;


}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"start");
    self.navigationController.hidesBarsWhenKeyboardAppears=YES;
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
   LightCView=[[UIVisualEffectView alloc]initWithEffect:blur];
    LightCView.frame=CGRectMake(0, 70,KSCREEM_WIDTH, KSCREEM_HEIGHT);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [LightCView addGestureRecognizer:tap];
    [self.view addSubview:LightCView];


}
-(void)backAction:(UITapGestureRecognizer *)gest{

   [UIView animateWithDuration:0.2 animations:^{
       LightCView.alpha=0;
       self.navigationController.navigationBarHidden=NO;

   } completion:^(BOOL finished) {
       [LightCView removeFromSuperview];
       UITextField *textFiled=(UITextField *)[self.view viewWithTag:666];
       [textFiled resignFirstResponder];
   }];


}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        NSLog(@"------");
    
    if (scrollView==adImageScrollV) {
       
                int numberPage=scrollView.contentOffset.x/375;
        
        UIPageControl *pageC=(UIPageControl *)[self.tableView viewWithTag:555];
        pageC.currentPage=numberPage;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==adImageScrollV) {
        NSLog(@"%f",scrollView.contentOffset.x);

        if (scrollView.contentOffset.x<0) {
            [self circulateDirection:KLeft];
        }
        else if (scrollView.contentOffset.x>KSCREEM_WIDTH*2){

            [self circulateDirection:kRight];
        }

    }

}
//用来滑动滚动视图循环滚动 交换imageview的image
-(void)circulateDirection:(BOOL)leftOrRight{
//    当滑动过界限时候 改变滚动视图contentoffset的位置
    [adImageScrollV setContentOffset:CGPointMake(KSCREEM_WIDTH, 0)];

    UIImage *changeImage;
    UIImageView *firstIV=(UIImageView *)[adImageScrollV viewWithTag:1001];
    UIImageView *secondIV=(UIImageView *)[adImageScrollV viewWithTag:1002];
    UIImageView *thirdIV=(UIImageView *)[adImageScrollV viewWithTag:1003];

    if (leftOrRight==KLeft) {
           changeImage=thirdIV.image;
           thirdIV.image=secondIV.image;
           secondIV.image=firstIV.image;
           firstIV.image=changeImage;
    }
    else if (leftOrRight==kRight){
        changeImage=firstIV.image;
        firstIV.image=secondIV.image;
        secondIV.image=thirdIV.image;
        thirdIV.image=changeImage;
        
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfier=@"activityCell";
    OCATTableViewCell *activityCell=(OCATTableViewCell *)[tableView dequeueReusableCellWithIdentifier:idenfier];
    
    return activityCell;
   


}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellCount;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120;
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
