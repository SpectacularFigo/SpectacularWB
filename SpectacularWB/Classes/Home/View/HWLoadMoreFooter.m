

#import "HWLoadMoreFooter.h"

@implementation HWLoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWLoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
