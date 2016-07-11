

#import "HWTest1ViewController.h"
#import "HWTest2ViewController.h"

@interface HWTest1ViewController ()

@end

@implementation HWTest1ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    HWTest2ViewController *test2 = [[HWTest2ViewController alloc] init];
    test2.title = @"测试2控制器";
    [self.navigationController pushViewController:test2 animated:YES];
}

@end
