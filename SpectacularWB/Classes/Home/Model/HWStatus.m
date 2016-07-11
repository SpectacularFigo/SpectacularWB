
#import "HWStatus.h"
#import "MJExtension.h"
#import "HWPhoto.h"
@implementation HWStatus

-(NSDictionary*)objectClassInArray
{
    
    return @{@"pic_urls":[HWPhoto class]};    // 这个的意思就是这个pic_urls数据中
    
    
    
}
@end
