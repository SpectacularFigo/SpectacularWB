

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 昵称字体
#define HWStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define HWStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define HWStatusCellSourceFont HWStatusCellTimeFont
// 正文字体
#define HWStatusCellContentFont [UIFont systemFontOfSize:14]
// 转发文字字体
#define HWStatusCellRetweetedContentFont [UIFont systemFontOfSize:12]

#define HWStatusCellToolBarMargin 5
@class HWStatus;

@interface HWStatusFrame : NSObject

@property (nonatomic, strong) HWStatus *status;




/** 原创微博*/
/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;





/** 转发微博 */
/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetedViewF;

/** 转发微博name and content */
@property (nonatomic, assign) CGRect retweetedContentLabelF;

/** 转发微博的配图*/
@property (nonatomic, assign) CGRect retweetedPhotoImageViewF;



/** 工具条*/
@property (nonatomic, assign) CGRect toolBarF;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
