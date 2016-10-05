

#import "HWHomeViewController.h"
#import "HWDropdownMenu.h"
#import "HWTitleMenuViewController.h"
#import "AFNetworking.h"
#import "HWAccountTool.h"
#import "HWTitleButton.h"
#import "UIImageView+WebCache.h"
#import "HWUser.h"
#import "HWStatus.h"
#import "MJExtension.h"
#import "HWLoadMoreFooter.h"
#import "HWStatusCell.h"
#import "HWStatusFrame.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "HWStatusOfflineTool.h"
@interface HWHomeViewController () <HWDropdownMenuDelegate>
/**
 *  微博数组（里面放的都是HWStatusFrame模型，一个HWStatusFrame对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation HWHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HWStatus *status in statuses) {
        HWStatusFrame *f = [[HWStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor=[UIColor grayColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
    
    // 1.设置导航栏内容
    [self setupNav];
    
    // 2.获得用户信息（昵称）
    [self setupUserInfo];
    
    // 3.集成下拉刷新控件
    [self setupDownRefresh];
    
    
    // 4.只是添加上拉刷新的控件到tableView上面去，就是添加一个footerView. 至于是否对服务器发送请求，是这样的。通过了scrollView的代理方法，知道了滑动到了最后面，然后在调用了loadMoreStatus这个方法来加载阁夺得数据。
    [self setupUpRefresh];
    
    
    
    // 5.获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#warning 重要 重看scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
}

// 1.friend search method  ==> setup Nav
- (void)friendSearch
{
    NSLog(@"friendSearch");
}

// 1.pop method ==> setup Nav
- (void)pop
{
    NSLog(@"pop");
}

/**
 *  1. 标题点击 ==> setup Nav
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    HWDropdownMenu *menu = [HWDropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}

#pragma mark - 1.设置导航栏内容
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    HWTitleButton *titleButton = [[HWTitleButton alloc] init];
    
    // 设置图片和文字
    NSString *name = [HWAccountTool account].name;
    [titleButton setTitle:name?name:@"Home" forState:UIControlStateNormal];
    
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    
}
#pragma mark - 2.获得用户信息（昵称）
- (void)setupUserInfo
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"access_token"] = account.access_token;
    //    params[@"uid"] = account.uid;
    [params setValue:account.access_token forKey:@"access_token"];
    [params setValue:account.uid   forKey:@"uid"];
    
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        HWUser *user = [HWUser objectWithKeyValues:responseObject];
        
        //        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        
        account.name = user.name;
        
        [HWAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        HWLog(@"请求失败-%@", error);
    }];
}
#pragma mark - 3.集成下拉刷新控件
- (void)setupDownRefresh
{
    // 1.添加刷新控件  继承自UIControl
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    
    // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
    [control addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [control beginRefreshing];
    
    
    // 3.马上加载数据
    [self loadNewStatus:control];
}

/**
 *  3. UIRefreshControl进入刷新状态：加载最新的数据 ===> 集成下拉刷新控件
 */
- (void)loadNewStatus:(UIRefreshControl *)control
{
    
    // 将一些常用的代码整理在一起，形成一段block 这样就是能够重复使用，但是要记住block只是局部变量
    
    void(^dealingResult)(NSArray*)=^(NSArray * statuses)
    {
                // 将 "微博字典"数组 转为 "微博模型"数组
                NSArray *newStatuses = [HWStatus objectArrayWithKeyValuesArray:statuses];
        
                // 将 HWStatus数组 转为 HWStatusFrame数组
                NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
                // 将最新的微博数据，添加到总数组的最前面
                NSRange range = NSMakeRange(0, newFrames.count);
                NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.statusFrames insertObjects:newFrames atIndexes:set];
        
                // 刷新表格 重新调用tableView的那几个数据源和代理方法
                [self.tableView reloadData];
        
                // 结束刷新
                [control endRefreshing];
                
                // 显示最新微博的数量
                [self showNewStatusCount:newStatuses.count];
    };
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    HWStatusFrame *firstStatusF = [self.statusFrames firstObject];
    
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    // 3. 判断数据库中是否有大于或者等于的since_id的status，如果有就是数据库中新的微博，如果没有就是数据库中没有现成的微博，需要发送网络请求
    NSArray * databaseReturnedData=[HWStatusOfflineTool offineStatusWithDictionary:params];
    
    if (databaseReturnedData.count) {
        dealingResult(databaseReturnedData);
    }
    else{
        // 3.发送请求
        [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            // NSLog(@"%@", responseObject);
            
            //1. 请求完数据先将数据存储在数据中
            [HWStatusOfflineTool saveStatus:[responseObject objectForKey:@"statuses"]];
            // 2.
            dealingResult([responseObject objectForKey:@"statuses"]);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            // HWLog(@"请求失败-%@", error);
            
            // 结束刷新刷新
            [control endRefreshing];
        }];
    }

}

/**
 *  3. 黄色Label显示最新微博的数量  ===> 集成下拉刷新控件  loadNewStatus 之后调用
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(int)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"No new Weibos, try it later";
    } else {
        label.text = [NSString stringWithFormat:@"%d new Weibos Loaded", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    
    
    // 3.添加 （设置的是label的初始位置,没出现的位置）
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;  // 回归原型
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}

#pragma mark - 4.集成上拉刷新控件
- (void)setupUpRefresh
{
    HWLoadMoreFooter *footer = [HWLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

#pragma mark - 5. tabBarItem 显示未读微博数
- (void)setupUnreadCount
{
    //    HWLog(@"setupUnreadCount");
    //    return;
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
        
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 6.加载更多的微博数据 通过scrollView 代理方法之后调用
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    HWStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [HWStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        HWLog(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}

#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(HWDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(HWDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    HWStatusCell *cell = [HWStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}



@end
