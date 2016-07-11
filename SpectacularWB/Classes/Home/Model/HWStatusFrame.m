

#import "HWStatusFrame.h"
#import "HWStatus.h"
#import "HWUser.h"

// cell的边框宽度
#define HWStatusCellBorderW 10


@implementation HWStatusFrame

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW    //对文本进行约束
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}




- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}


- (void)setStatus:(HWStatus *)status
{
    _status = status;
    
    HWUser *user = status.user;
    HWStatus * retweeted_status=status.retweeted_status;
    HWUser *retweeteduser=status.retweeted_status.user;
    
    /**
     *  原创微博的尺寸计算
     */
    
    
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);

    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HWStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};

    
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HWStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }

    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:HWStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};

    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + HWStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:HWStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + HWStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [self sizeWithText:status.text font:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalViewH=0;
    
    if(status.pic_urls.count)  // 如果有配图
    {
        CGFloat photoX=iconX;
        CGFloat photoY=CGRectGetMaxY(self.contentLabelF)+HWStatusCellBorderW;
        CGFloat photoWH=100;
        self.photoViewF=CGRectMake(photoX, photoY, photoWH, photoWH);
        originalViewH=CGRectGetMaxY(self.photoViewF)+HWStatusCellBorderW;
    }
    else    // 如果没有配图
    {
        
        originalViewH=CGRectGetMaxY(self.contentLabelF)+HWStatusCellBorderW;
        
        
        
    }
    
    /** 原创微博整体 */
    CGFloat originalViewX = 0;
    CGFloat originalViewY = HWStatusCellBorderW;
    CGFloat originalViewW = cellW;
    self.originalViewF=CGRectMake(originalViewX, originalViewY, originalViewW, originalViewH);
    
    
    /**
     *  转发微博的尺寸计算
     *
     */
    CGFloat toolBarY=0;
    if (retweeted_status) {                 // 如果有转发微博
        CGFloat retweetedViewH=0;
        /** 转发微博name and content */
        CGFloat retweetedContentX=HWStatusCellBorderW;
        CGFloat retweetedContentY=HWStatusCellBorderW;
        
        NSString * retweetedContent=[NSString stringWithFormat:@"@%@:,%@",retweeteduser.name,retweeted_status.text];
        CGSize  retweetedContentSize=[self sizeWithText: retweetedContent font:HWStatusCellRetweetedContentFont maxW:maxW];
        self.retweetedContentLabelF=(CGRect){{retweetedContentX,retweetedContentY},retweetedContentSize};
        
        if (retweeted_status.pic_urls.count) {
            /** 转发微博的配图*/
                CGFloat   retweetedPhotoImageViewX=HWStatusCellBorderW;
                CGFloat   retweetedPhotoImageViewY=CGRectGetMaxY(self.retweetedContentLabelF)+HWStatusCellBorderW;
                CGFloat   retweetedPhotoImageViewWH=100;
                self.retweetedPhotoImageViewF=CGRectMake(retweetedPhotoImageViewX, retweetedPhotoImageViewY, retweetedPhotoImageViewWH, retweetedPhotoImageViewWH);
            retweetedViewH=CGRectGetMaxY(self.retweetedPhotoImageViewF)+HWStatusCellBorderW;

        }
        else {
            retweetedViewH=CGRectGetMaxY(self.retweetedContentLabelF)+HWStatusCellBorderW;
         }
        
        /** 转发微博整体*/
        CGFloat retweetedViewX=0;
        CGFloat retweetedViewY=CGRectGetMaxY(self.originalViewF);
        CGFloat retweetedViewW=cellW;
        self.retweetedViewF=CGRectMake(retweetedViewX, retweetedViewY, retweetedViewW, retweetedViewH);
        toolBarY=CGRectGetMaxY(self.retweetedViewF);
    }
    
    else {
        toolBarY=CGRectGetMaxY(self.originalViewF);
    }
    CGFloat toolBarX=0;
    CGFloat toolBarW=cellW;
    CGFloat toolBarH=20;
    self.toolBarF=CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    self.cellHeight=CGRectGetMaxY(self.toolBarF);

}
@end
