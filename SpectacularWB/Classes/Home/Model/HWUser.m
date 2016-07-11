
#import "HWUser.h"

@implementation HWUser

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

//- (BOOL)isVip
//{
//    return self.mbrank > 2;
//}
@end
