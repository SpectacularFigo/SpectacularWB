

#import "HWTabBarViewController.h"
#import "HWHomeViewController.h"
#import "HWMessageCenterViewController.h"
#import "HWDiscoverViewController.h"
#import "HWProfileViewController.h"
#import "HWNavigationController.h"
#import "HWTabBar.h"
#import "HWComposeViewController.h"
#import "Method.h"
@interface HWTabBarViewController () <HWTabBarDelegate>

@end

@implementation HWTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 1.初始化子控制器
    HWHomeViewController *home = [[HWHomeViewController alloc] init];
    [self addChildVc:home title:@"Home" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    HWMessageCenterViewController *messageCenter = [[HWMessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"Message" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    HWDiscoverViewController *discover = [[HWDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"Discover" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    HWProfileViewController *profile = [[HWProfileViewController alloc] init];
    [self addChildVc:profile title:@"Me" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    
    
    
//    [NSNotificationCenter defaultCenter] addObserver:self selector:@(asdf:) name: object:<#(nullable id)#>
    
    
    // 2.更换系统自带的tabbar
    HWTabBar *tabBar = [[HWTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabBar的delegate就是HWTabBarViewController
     说明，不用再设置tabBar.delegate = self;
     */
    
    /*
     1.如果tabBar设置完delegate后，再执行下面代码修改delegate，就会报错
     tabBar.delegate = self;

     2.如果再次修改tabBar的delegate属性，就会报下面的错误
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误意思：不允许修改TabBar的delegate属性(这个TabBar是被TabBarViewController所管理的)
     */
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HWNavigationController *nav = [[HWNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}


#pragma mark - HWTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(HWTabBar *)tabBar
{
    HWComposeViewController *composeViewController = [[HWComposeViewController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
    
    HWNavigationController *  navigationController=[[HWNavigationController alloc]initWithRootViewController:composeViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
