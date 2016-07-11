

#import <Foundation/Foundation.h>
#import "HWAccount.h"

@interface HWAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(HWAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (HWAccount *)account;
@end
