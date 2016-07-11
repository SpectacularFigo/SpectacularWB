

#import <Foundation/Foundation.h>
@class HWUser;

@interface HWStatus : NSObject
/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) HWUser *user;        //新浪文档中user对应的是一个字典所以用MJExtension 直接对HWUser 进行了字典转模型

/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/**  微博配图地址。多图时返回多图链接。图配返回‘[]’*/

@property (nonatomic,strong) NSArray * pic_urls;

@property(nonatomic, strong) HWStatus*retweeted_status;

/** 转发数*/
@property (nonatomic, assign) int reposts_count;
/** number of reposts*/
@property (nonatomic, assign) int comments_count;
/** number of attitude*/
@property (nonatomic, assign) int attitudes_count;

@end
